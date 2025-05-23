import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:packup/model/chat/chat_room_model.dart';
import 'package:path/path.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'package:packup/common/util.dart';
import 'package:packup/const/const.dart';
import 'package:packup/model/chat/chat_message_model.dart';
import 'package:packup/provider/chat/chat_message_provider.dart';
import 'package:packup/provider/chat/chat_room_provider.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  final String socketPrefix = dotenv.env['SOCKET_URL']!;
  late ChatMessageProvider chatMessageProvider;
  late ChatRoomProvider chatRoomProvider;
  StompClient? stompClient;

  // ▼ 구독 리스트
  int chatRoomSeq = 0;
  StompUnsubscribe? chatRoomSubscription;     // 채팅방 리스트 구독
  StompUnsubscribe? chatMessageSubscription;  // 채팅 리스트 구독
  // ▲ 구독 리스트

  bool isConnect = false;       // 현재 연결 여부
  bool isReconnecting = false;  // 재연결 시도 상태 여부
  bool forceDisconnect = false;  // 강제로 소켓 해제

  Future<void> initConnect() async {
    if (stompClient != null) {
      if (stompClient!.isActive && isConnect) {
        print("이미 소켓이 연결 되어 있음.");
        return;
      } else {
        stompClient!.deactivate();
        stompClient = null;
      }
    }

    print("소켓을 연결합니다.");
    await initStompClient();
    stompClient!.activate();

    Future.delayed(Duration(seconds: 5), () {
      if (!isConnect) {
        reconnect();
      }
    });
  }

  void setMessageProvider(ChatMessageProvider provider) {
    chatMessageProvider = provider;
  }

  void setRoomProvider(ChatRoomProvider provider) {
    chatRoomProvider = provider;
  }

  Future<void> initStompClient() async {
    String? token = await getToken(ACCESS_TOKEN);
    String? refreshToken = await getToken(REFRESH_TOKEN);

    if (token == null || tokenExpired(token)) {
      if (refreshToken != null) {
        try {
          final dio = Dio();
          final res = await dio.post(
            '${dotenv.env['HTTP_URL']!}/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          final newAccessToken = res.data['response']['accessToken'];
          await saveToken(ACCESS_TOKEN, newAccessToken);
          token = newAccessToken;
        } catch (e) {
          print("소켓 연결 전 access token refresh 실패");
          return;
        }
      }
    }

    stompClient = StompClient(
      config: StompConfig(
        url: socketPrefix,
        onConnect: onConnect,
        onDisconnect: onDisconnect,
        beforeConnect: () async {
          await Future.delayed(const Duration(milliseconds: 200));
        },
        onWebSocketError: (dynamic error) {
          logger(error.toString(), 'ERROR');
          reconnect();
        },
        onStompError: (frame) {
          print('[SocketService] STOMP 에러: ${frame.body}');
          reconnect();
        },
        stompConnectHeaders: {'Authorization': "Bearer $token"},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  void onConnect(StompFrame frame) {
    print("소켓 연결 완료.");
    isConnect = true;

    // 재구독
    reSubscribe();

    // 연결 유지용 ping
    Timer.periodic(const Duration(seconds: 100), (_) {
      try {
        if (stompClient != null && stompClient!.isActive) {
          stompClient!.send(
            destination: '/pub/send.connection',
            body: 'keep connection',
          );
        }
      } catch (e, stackTrace) {
        print('ping 전송 중 예외: $e');
        reconnect();
      }
    });
  }

  /// 채팅방 리스트 구독
  void subscribeChatRoom() {
    chatRoomSubscription?.call();
    print("채팅방 리스트 구독 시작");

    chatRoomSubscription = stompClient!.subscribe(
      destination: '/user/queue/chatroom-refresh',
      callback: (frame) {
        if (frame.body != null) {
          final data = json.decode(frame.body!);
          final newFirstChatRoom = ChatRoomModel.fromJson(data);
          chatRoomProvider.updateFirstChatRoom(newFirstChatRoom);
        }
      },
    );
  }

  /// 채팅방 리스트 구독 해제
  void unsubscribeChatRoom() {
    chatRoomSubscription?.call();
    chatRoomSubscription = null;
    print("채팅방 리스트 구독 해제 완료");
  }

  /// 채팅방 메시지 구독
  void subscribeChatMessage(int chatRoomSeq) {
    chatMessageSubscription?.call(); // 기존 구독 해제
    print("채팅방 [$chatRoomSeq] 메시지 구독 시작");
    this.chatRoomSeq = chatRoomSeq;

    chatMessageSubscription = stompClient!.subscribe(
      destination: '/topic/chat/room/$chatRoomSeq',
      callback: (frame) {
        if (frame.body != null) {
          final data = json.decode(frame.body!);
          final newChatMessage = ChatMessageModel.fromJson(data);
          print("새로운 채팅이 추가 완료.");
          chatMessageProvider.addMessage(newChatMessage);
        }
      },
    );
  }

  /// 채팅방 메시지 구독 해제
  void unsubscribeChatMessage() {
    chatMessageSubscription?.call();
    chatMessageSubscription = null;
    chatRoomSeq = 0;
    print("채팅방 메시지 구독 해제 완료");
  }

  /// 메시지 전송
  void sendMessage(ChatMessageModel chatMessageModel) {
    stompClient!.send(
      destination: '/pub/send.message',
      body: chatMessageModel.toJson(),
      headers: {'content-type': 'application/json'},
    );
  }

  /// 전체 연결 해제
  void disconnect() {
    print("소켓을 해지");
    unsubscribeChatRoom();
    unsubscribeChatMessage();
    stompClient?.deactivate();

    forceDisconnect = true;
  }

  void onDisconnect(StompFrame frame) {
    print("소켓 연결 해제됨.");
    reconnect();
  }

  void reconnect() {
    isConnect = false;

    if(forceDisconnect) {
      print("앱이 백그라운드 혹은 종료 되어 소켓 연결을 해제 합니다.");
      return;
    }

    // 예시 조건: 이미 연결된 상태면 재연결 안 함
    if (isConnect) {
      print("이미 연결되어 있어 재연결하지 않음.");
      return;
    }

    // 이미 재연결 중이면 중복 방지
    if (isReconnecting) {
      print("이미 재연결 중... 중복 방지.");
      return;
    }

    isReconnecting = true;

    Future.delayed(const Duration(seconds: 5), () {
      print("소켓 재연결 시도...");
      initConnect();
      isReconnecting = false;
      forceDisconnect = false;
    });
  }


  void reSubscribe() {
    if(chatMessageSubscription != null && stompClient != null) {
      print("채팅을 재구독." + chatRoomSeq.toString());
      subscribeChatMessage(chatRoomSeq);
    }

    if(chatRoomSubscription != null && stompClient != null) {
      print("채팅방 리스트를 재구독.");
      subscribeChatRoom();
    }
  }
}

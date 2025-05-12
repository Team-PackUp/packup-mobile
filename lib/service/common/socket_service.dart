import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:packup/model/chat/ChatRoomModel.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'package:packup/common/util.dart';
import 'package:packup/const/const.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';
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

  StompUnsubscribe? chatRoomSubscription;
  StompUnsubscribe? chatMessageSubscription;

  bool isConnect = false;

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
        print("소켓 최초 연결 응답 없음. 재연결 시도");
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
          isConnect = false;
          reconnect();
        },
        onStompError: (frame) {
          print('[SocketService] STOMP 에러: ${frame.body}');
          isConnect = false;
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
    // 연결 유지용 ping
    Timer.periodic(const Duration(seconds: 10), (_) {
      try {
        if (stompClient != null && stompClient!.isActive) {
          stompClient!.send(
            destination: '/pub/send.connection',
            body: 'keep connection',
          );
        }
      } catch (e, stackTrace) {
        isConnect = false;
        print('ping 전송 중 예외: $e');
        print(stackTrace);
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
  }

  void onDisconnect(StompFrame frame) {
    print("소켓 연결 해제됨.");
    reconnect();
  }

  void reconnect() {

    Future.delayed(const Duration(seconds: 5), () {
      print("소켓 재연결 시도...");
      initConnect();
    });
  }
}

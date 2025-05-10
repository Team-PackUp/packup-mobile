import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'package:packup/common/util.dart';

import 'package:packup/const/const.dart';

import 'package:packup/model/chat/ChatMessageModel.dart';
import 'package:packup/provider/chat/chat_message_provider.dart';

import '../../provider/chat/chat_room_provider.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  // 객체 생성 방지
  SocketService._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory SocketService() {
    return _instance;
  }

  final String socketPrefix = dotenv.env['SOCKET_URL']!;

  int? chatRoomSeq;
  late ChatMessageProvider chatMessageProvider;
  late ChatRoomProvider chatRoomProvider;
  late StompClient stompClient;

  bool socketPage = true;

  Future<void> initConnect(chatRoomSeq) async {
    if (chatRoomSeq > 0) {
      this.chatRoomSeq = chatRoomSeq;
      return;
    }

    print("소켓을 연결합니다.");
    await initStompClient();

    stompClient.activate();
  }

  void setMessageProvider(ChatMessageProvider chatMessageProvider) {
    this.chatMessageProvider = chatMessageProvider;
  }

  void setRoomProvider(ChatRoomProvider chatRoomProvider) {
    this.chatRoomProvider = chatRoomProvider;
  }

  Future<void> initStompClient() async {
    socketPage = true;

    final token = await getToken(ACCESS_TOKEN);

    stompClient = StompClient(
      config: StompConfig(
        url: '$socketPrefix/chat',
        onConnect: onConnect,
        onDisconnect: onDisconnect,
        beforeConnect: () async {
          await Future.delayed(const Duration(milliseconds: 200));
        },
        onWebSocketError: (dynamic error) {
          logger(error.toString(), 'ERROR');
          reconnect();
        },
        stompConnectHeaders: {'Authorization': "Bearer $token"},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  void onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/topic/chat/room/$chatRoomSeq',
      callback: (frame) {
        if (frame.body != null) {
          final data = json.decode(frame.body!);
          final newChatMessage = ChatMessageModel.fromJson(data);
          chatMessageProvider.addMessage(newChatMessage);
        }
      },
    );

    stompClient.subscribe(
      destination: '/user/queue/chatroom-refresh',
      callback: (frame) {
        final updatedRoom = frame.body!;
        chatRoomProvider.getRoom(0); // 3번 방 정보 최신화
      },
    );

    Timer.periodic(const Duration(seconds: 10), (_) {
      stompClient.send(
        destination: '/pub/send.connection',
        body: 'keep connection',
      );
    });
  }

  void sendMessage(ChatMessageModel chatMessageModel) {
    stompClient.send(
      destination: '/pub/send.message', // STOMP 라우팅 키워드
      body: chatMessageModel.toJson(),
      headers: {'content-type': 'application/json'},
    );
  }

  void disconnect() {
    print("소켓을 해지합니다.");

    stompClient.deactivate();
    socketPage = false;
  }

  void onDisconnect(StompFrame frame) {
    if(!socketPage) return;
    reconnect();
  }

  void reconnect() {
    if (stompClient.isActive) return;

    Future.delayed(const Duration(seconds: 5), () {
      stompClient.activate();
    });
  }

}

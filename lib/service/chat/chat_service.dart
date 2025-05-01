import 'dart:async';
import 'dart:convert';
import 'package:packup/Common/util.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:packup/http/dio_service.dart';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../const/const.dart';

class ChatService {

  static final ChatService _instance = ChatService._internal();

  // 객체 생성 방지
  ChatService._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory ChatService() {
    return _instance;
  }

  int? chatRoomSeq;

  late StompClient stompClient;
  final String httpPrefix = dotenv.env['HTTP_URL']!;
  final String socketPrefix = dotenv.env['SOCKET_URL']!;

  /// HTTP header
  Future<Map<String, String>> get header async => {
    'Content-Type': 'application/json',
    // HttpHeaders.authorizationHeader: 'Bearer ${await getToken()}'
  };

  /// 1. 채팅방 생성 (HTTP)
  Future<ResultModel> createRoom(List receiver) async {

    final data = {'receiver' : receiver};

    return await DioService().postRequest('/createRoom', data);
  }

  /// 2. 채팅방 목록 조회 (HTTP)
  Future<ResultModel> getRoom() async {

    return await DioService().getRequest('/chat/room/list');
  }

  /// 3. 채팅 내역 가져오기 (HTTP)
  Future<ResultModel> getMessage(int chatRoomSeq) async {

    return await DioService().getRequest("/chat/message/list/$chatRoomSeq");
  }

  Future<void> initConnect(chatRoomSeq) async {
    this.chatRoomSeq = chatRoomSeq;

    print("커넥트 시작");

    await initStompClient();

    stompClient.activate();
  }

  Future<void> initStompClient() async {
    final token = await getToken(ACCESS_TOKEN);
    print(token);

    stompClient = StompClient(
      config: StompConfig(
        url: '$socketPrefix/chat',
        onConnect: onConnect,
        beforeConnect: () async {
          await Future.delayed(const Duration(milliseconds: 200));
        },
        onWebSocketError: (dynamic error) => logger(error.toString(), 'ERROR'),
        stompConnectHeaders: {'Authorization': "Bearer $token"},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );
  }


  void onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/sub/chat/room/$chatRoomSeq',
      callback: (frame) {
        final result = json.decode(frame.body!);
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
      destination: '/pub/send.message',
      body: chatMessageModel.toJson(),
      headers: {'content-type': 'application/json'},
    );
  }

  void disconnect() {
    stompClient.deactivate();
  }
}

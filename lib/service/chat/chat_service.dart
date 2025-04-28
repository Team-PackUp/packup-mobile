import 'dart:async';
import 'dart:convert';
import 'package:packup/model/common/result_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:packup/http/dio_service.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';

class ChatService {

  static final ChatService _instance = ChatService._internal();

  // 객체 생성 방지
  ChatService._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory ChatService() {
    return _instance;
  }


  final String httpPrefix = dotenv.env['HTTP_URL']!;
  final String socketPrefix = dotenv.env['SOCKET_URL']!;
  WebSocketChannel? _channel;
  Stream? _stream;

  /// HTTP header
  Future<Map<String, String>> get header async => {
    'Content-Type': 'application/json',
    // HttpHeaders.authorizationHeader: 'Bearer ${await getToken()}'
  };

  /// 1. 채팅방 생성 (HTTP)
  Future<ResultModel> createRoom(List receiver) async {

    final data = {'receiver' : receiver};

    final response = await DioService().postRequest('/createRoom', data);

    return ResultModel.fromJson(response.response);
  }

  /// 2. 채팅방 목록 조회 (HTTP)
  Future<ResultModel> getRoom() async {

    final response = await DioService().getRequest('/chat/room/list');

    return response;
  }

  /// 3. 채팅 내역 가져오기 (HTTP)
  Future<ResultModel> getMessage(int chatRoomSeq) async {
    chatRoomSeq = 2;
    final response = await DioService().getRequest("/chat/message/list/$chatRoomSeq");

    return ResultModel.fromJson(response.response);
  }

  /// 5. WebSocket 연결
  void connectWebSocket(int chatRoomSeq) {
    print(chatRoomSeq);
    print("$socketPrefix/chat_message?chatRoomSeq=$chatRoomSeq");
    final uri = Uri.parse("$socketPrefix/ws/chat_message?chatRoomSeq=$chatRoomSeq");
    try {
      // _channel = WebSocketChannel.connect(
      //   Uri.parse('ws://10.0.2.2:8080/ws/chat'),
      // );
      // 연결 성공 시 로직
    } catch (e) {
      print('WebSocket connection error: $e');
    }
  }

  /// 6. WebSocket 메시지 보내기
  void sendMessage(ChatMessageModel chat) {
    print(chat);
    if (_channel != null) {
      print("메시지 발송 ");
      _channel!.sink.add(chat.message);
    }
  }

  /// 7. WebSocket 메시지 수신 스트림
  Stream<dynamic> get messageStream => _stream!;

  /// 8. 연결 종료
  void disconnect() {
    print("소켓 해제");
    _channel?.sink.close();
    _channel = null;
  }
}

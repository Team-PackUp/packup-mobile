import 'dart:async';
import 'dart:convert';
import 'package:packup/model/common/result_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../http/dio_service.dart';
import '../../model/chat/ChatModel.dart';

class ChatService {
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
  Future<ResultModel> createRoom(Map<String, dynamic> data) async {
      return await DioService().postRequest('/createRoom', data);
  }

  /// 2. 채팅방 목록 조회 (HTTP)
  Future<ResultModel> getRoom() async {
    return await DioService().getRequest('/chatRoom');
  }

  /// 3. 채팅 내역 가져오기 (HTTP)
  Future<ResultModel> getMessage(Map<String, dynamic> data) async {
    return await DioService().getRequest('/chat/getMessage', data);
  }

  /// 4. 메시지 저장 (HTTP - DB 영속화)
  Future<ResultModel> saveMessage(Map<String, dynamic> data) async {
    return await DioService().postRequest('/saveMessage', data);
  }

  /// 5. WebSocket 연결
  void connectWebSocket(int roomId) {
    final uri = Uri.parse("$socketPrefix/ws/chat?roomId=$roomId");
    _channel = WebSocketChannel.connect(uri);
    _stream = _channel!.stream.asBroadcastStream();
  }

  /// 6. WebSocket 메시지 보내기
  void sendMessage(ChatModel chat) {
    if (_channel != null) {
      _channel!.sink.add(json.encode(chat.toJson()));
    }
  }

  /// 7. WebSocket 메시지 수신 스트림
  Stream<dynamic> get messageStream => _stream!;

  /// 8. 연결 종료
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}

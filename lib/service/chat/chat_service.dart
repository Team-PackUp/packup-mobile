import 'dart:async';
import 'dart:convert';
import 'package:packup/model/common/result_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../http/dio_service.dart';
import '../../model/chat/ChatModel.dart';

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

    return ResultModel.fromJson(response.response);
  }

  /// 3. 채팅 내역 가져오기 (HTTP)
  Future<ResultModel> getMessage(int chatRoomId) async {

    final data = {'chat_room_id' : chatRoomId};

    final response = await DioService().getRequest('/chat/getMessage', data);

    return ResultModel.fromJson(response.response);
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

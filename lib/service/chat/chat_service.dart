import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:packup/http/dio_service.dart';

class ChatService {

  static final ChatService _instance = ChatService._internal();

  // 객체 생성 방지
  ChatService._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory ChatService() {
    return _instance;
  }

  final String httpPrefix = dotenv.env['HTTP_URL']!;

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
  Future<ResultModel> getRoom(int page) async {
    final data = {'page' : page};
    return await DioService().getRequest('/chat/room/list', data);
  }

  /// 3. 채팅 내역 가져오기 (HTTP)
  Future<ResultModel> getMessage(int chatRoomSeq, int page) async {
    final data = {'page' : page};
    return await DioService().getRequest("/chat/message/list/$chatRoomSeq", data);
  }

  Future<ResultModel> sendFile(XFile file) async {

    return await DioService().multipartRequest("/chat/message/save/file", file);
  }
}

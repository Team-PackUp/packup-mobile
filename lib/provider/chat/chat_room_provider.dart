import 'package:flutter/material.dart';
import 'package:packup/service/chat/chat_service.dart';

import '../../model/chat/ChatRoomModel.dart';

class ChatRoomProvider with ChangeNotifier {

  final ChatService chatService = ChatService();

  bool _isLoading = false;

  List<ChatRoomModel> _chatRoom = [];

  bool get isLoading => _isLoading;
  List<ChatRoomModel> get chatRoom => _chatRoom;

  // 채팅방 리스트
  getRoom() async {
    if (_isLoading) return; // 중복 호출 방지
    _isLoading = true;

    try {
      final response = await chatService.getRoom();
      final responseList = response.response as List;

      List<ChatRoomModel> chatRoomList = responseList
          .map((data) => ChatRoomModel.fromJson(data))
          .toList();

      _chatRoom = chatRoomList;
      notifyListeners();
    } finally {
      _isLoading = false;
    }
  }
}
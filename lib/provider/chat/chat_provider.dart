import 'package:flutter/material.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';
import 'package:packup/service/chat/chat_service.dart';

import '../../model/chat/ChatRoomModel.dart';

class ChatProvider with ChangeNotifier {
  final ChatService chatService = ChatService();

  bool _isLoading = false;

  late ChatMessageModel chatMessageModel;
  List<ChatRoomModel> _chatRoom = [];
  List<ChatMessageModel> _chatMessage = [];

  bool get isLoading => _isLoading;
  List<ChatRoomModel> get chatRoom => _chatRoom;
  List<ChatMessageModel> get chatMessage => _chatMessage;

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


  // 채팅 이력
  getMessage(int chatRoomSeq) async {
    _isLoading = true;

    final response = await chatService.getMessage(chatRoomSeq);

    final responseList = response.response as List;

    List<ChatMessageModel> messageList = responseList
        .map((data) => ChatMessageModel.fromJson(data))
        .toList();

    _chatMessage = messageList;

    notifyListeners();
  }

  void addMessage(ChatMessageModel message) {

    _chatMessage.insert(0, message);
    getRoom();
    notifyListeners();
  }
}
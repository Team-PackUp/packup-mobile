import 'package:flutter/material.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:packup/service/chat/chat_service.dart';

import 'package:packup/model/chat/ChatModel.dart';

class ChatProvider with ChangeNotifier {
  final ChatService chatService = ChatService();

  List<dynamic> _chatRoom = [];
  List<dynamic> get chatRoom => _chatRoom;

  setChatProvider(List<dynamic> chatRoom) {
    _chatRoom = chatRoom;
    notifyListeners();
  }

  getRoom() async {
    final response = await chatService.getRoom();
    setChatProvider(response.response);
  }

  Future<ResultModel> getMessage({
    required chatRoomId,
  }) async {

    final response = await chatService.getMessage(chatRoomId);

    return response;
  }

  Future<int> createChatRoom({
    required receiver
  }) async {
    final response = await chatService.createRoom(receiver);

    return response.response;
  }
}
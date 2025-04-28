import 'package:flutter/material.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';
import 'package:packup/service/chat/chat_service.dart';

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

  Future<List<ChatMessageModel>> getMessage(int chatRoomId) async {
    final response = await chatService.getMessage(chatRoomId);
    List<ChatMessageModel> getMessage = response.response;

    print(getMessage);

    return getMessage;
  }
}
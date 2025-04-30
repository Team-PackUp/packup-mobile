import 'package:flutter/material.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';
import 'package:packup/service/chat/chat_service.dart';

import '../../model/chat/ChatRoomModel.dart';

class ChatProvider with ChangeNotifier {
  final ChatService chatService = ChatService();

  late ChatMessageModel chatMessageModel;
  late List<ChatRoomModel> _chatRoom = [];
  late List<ChatMessageModel> _chatMessage;

  List<ChatRoomModel> get chatRoom => _chatRoom;
  List<ChatMessageModel> get chatMessage => _chatMessage;

  setChatRoomList(List<ChatRoomModel> chatRoomList) {
    _chatRoom = chatRoomList;
    notifyListeners();
  }

  // 채팅방 리스트
  getRoom() async {
    final response = await chatService.getRoom();

    List<ChatRoomModel> chatRoomList = (response.response as List)
        .map((data) => ChatRoomModel.fromJson(data))
        .toList();

    setChatRoomList(chatRoomList);
  }


  // 채팅 이력
  getMessage(int chatRoomId) async {
    final response = await chatService.getMessage(chatRoomId);
    List<ChatMessageModel> messageList = response.response;

    _chatMessage = messageList;
  }
}
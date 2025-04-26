import 'package:flutter/material.dart';
import 'package:packup/service/chat/chat_service.dart';

import 'package:packup/model/chat/ChatModel.dart';

class ChatProvider with ChangeNotifier {
  final ChatService chatService;

  ChatProvider({
    required this.chatService
  }) : super();

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

  Future<List<ChatModel>> getMessage({
    int? chatRoomId,
  }) async {
    final data = {'chat_room_id' : chatRoomId};
    final response = await chatService.getMessage(data);

    return response.response;
  }

  Future<int> createChatRoom({
    required receiver
  }) async {
    final data = {'receiver' : receiver};
    final response = await chatService.createRoom(data);

    return response.response;
  }
//
// void saveMessage({required ChatModel chatModel}) async {
//   Map<String, dynamic>? savedMessage = await repository.saveMessage(chatModel);
//   ChatModel newChat = ChatModel.fromJson(savedMessage?['response'] ?? {});
//   //
//   // // 기존 리스트 복제
//   List<ChatModel> totalList = List.from(_chatMessage ?? []);
//   totalList.add(newChat);
//
//   setChatMessageProvider(totalList);
// }
}
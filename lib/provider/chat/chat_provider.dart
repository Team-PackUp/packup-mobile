import 'package:flutter/material.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';
import 'package:packup/service/chat/chat_service.dart';

import '../../model/chat/ChatRoomModel.dart';
import '../../model/common/result_model.dart';

class ChatProvider with ChangeNotifier {
  final ChatService chatService = ChatService();

  bool _isLoading = false;

  late ChatMessageModel chatMessageModel;
  List<ChatRoomModel> _chatRoom = [];
  List<ChatMessageModel> _chatMessage = [];

  bool get isLoading => _isLoading;
  List<ChatRoomModel> get chatRoom => _chatRoom;
  List<ChatMessageModel> get chatMessage => _chatMessage;

  setChatRoomList(List<ChatRoomModel> chatRoomList) {
    _chatRoom = chatRoomList;
    notifyListeners();

    _isLoading = false;
  }

  setChatMessageList(List<ChatMessageModel> chatMessageList) {

    _chatMessage = chatMessageList;

    notifyListeners();

    _isLoading = false;
  }

  // 채팅방 리스트
  getRoom() async {
    _isLoading = true;

    final response = await chatService.getRoom();

    final responseList = response.response as List;

    List<ChatRoomModel> chatRoomList = responseList
        .map((data) => ChatRoomModel.fromJson(data))
        .toList();

    setChatRoomList(chatRoomList);
  }

  // 채팅 이력
  getMessage(int chatRoomSeq) async {
    _isLoading = true;

    final response = await chatService.getMessage(chatRoomSeq);

    final responseList = response.response as List;

    List<ChatMessageModel> messageList = responseList
        .map((data) => ChatMessageModel.fromJson(data))
        .toList();

    setChatMessageList(messageList);
  }

  void addMessage(ChatMessageModel message) {
    print("새로운 메시지 " + message.message.toString());

    _chatMessage.insert(0, message);
    notifyListeners();
    print("메시지 발송 상태 변경 감지");
  }
}
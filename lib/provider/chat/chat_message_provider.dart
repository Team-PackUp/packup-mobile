import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';
import 'package:packup/model/common/file_model.dart';
import 'package:packup/service/chat/chat_service.dart';

import '../../model/chat/ChatRoomModel.dart';

class ChatMessageProvider with ChangeNotifier {

  final ChatService chatService = ChatService();

  bool _isLoading = false;

  late ChatMessageModel chatMessageModel;
  List<ChatMessageModel> _chatMessage = [];

  bool get isLoading => _isLoading;
  List<ChatMessageModel> get chatMessage => _chatMessage;

  // 채팅 이력
  getMessage(int chatRoomSeq) async {
    _isLoading = true;

    final response = await chatService.getMessage(chatRoomSeq);

    final responseList = response.response as List;

    List<ChatMessageModel> messageList = responseList
        .map((data) => ChatMessageModel.fromJson(data))
        .toList();

    _chatMessage = messageList;
    print("메시지를 조회 합니다.");

    notifyListeners();
  }

  void addMessage(ChatMessageModel message) {
    // 중복된 seq 값을 가진 메시지가 있는지 확인
    bool exists = _chatMessage.any((msg) => msg.seq == message.seq);

    if (!exists) {
      print("알림 시작");
      _chatMessage.insert(0, message);
      notifyListeners(); // 상태 변경 후 한 번만 호출
    }
  }

  Future<FileModel> sendFile(XFile file) async {
    _isLoading = true;
    final response = await chatService.sendFile(file);
    FileModel fileModel = FileModel.fromJson(response.response);

    _isLoading = false;

    return fileModel;
  }
}
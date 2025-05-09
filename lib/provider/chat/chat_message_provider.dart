import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';
import 'package:packup/model/common/file_model.dart';
import 'package:packup/service/chat/chat_service.dart';

import 'package:packup/model/common/page_model.dart';

import 'package:packup/provider/common/LoadingProvider.dart';

class ChatMessageProvider extends LoadingNotifier {

  final ChatService chatService = ChatService();

  late ChatMessageModel chatMessageModel;
  List<ChatMessageModel> _chatMessage = [];
  int _totalPage = 0;

  List<ChatMessageModel> get chatMessage => _chatMessage;
  int get totalPage => _totalPage;

  // 메시지 로딩
  Future<void> getMessage(int chatRoomSeq, int page) async {
    if (_totalPage > page) return;

    await handleLoading(() async {
      final response = await chatService.getMessage(chatRoomSeq, page);
      PageModel pageModel = PageModel.fromJson(response.response);

      List<ChatMessageModel> messageList = pageModel.objectList
          .map((data) => ChatMessageModel.fromJson(data))
          .toList();

      _chatMessage.insertAll(0, messageList);
      _totalPage = pageModel.totalPage;
    });
  }

  Future<void> addMessage(ChatMessageModel message) async {

    await handleLoading(() async {
      bool exists = _chatMessage.any((msg) => msg.seq == message.seq);
      if (!exists) {
        _chatMessage.insert(0, message);
      }
    });
  }

  Future<FileModel> sendFile(XFile file) async {

    return await handleLoading(() async {
      final response = await chatService.sendFile(file);
      return FileModel.fromJson(response.response);

    });
  }
}
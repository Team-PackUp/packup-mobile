import 'package:flutter/material.dart';
import 'package:packup/model/common/page_model.dart';
import 'package:packup/service/chat/chat_service.dart';

import 'package:packup/model/chat/ChatRoomModel.dart';
import 'package:packup/provider/common/loading_provider.dart';

import '../../service/common/loading_service.dart';

class ChatRoomProvider extends LoadingProvider {

  final ChatService chatService = ChatService();

  List<ChatRoomModel> _chatRoom = [];
  int _totalPage = 0;

  List<ChatRoomModel> get chatRoom => _chatRoom;
  int get totalPage => _totalPage;

  // 채팅방 리스트
  getRoom(int page) async {
    if(_totalPage > page) return;

    await LoadingService.run(() async {
      final response = await chatService.getRoom(page);
      PageModel pageModel = PageModel.fromJson(response.response);

      final responseList = pageModel.objectList;
      int totalPage  = pageModel.totalPage;

      List<ChatRoomModel> chatRoomList = responseList
          .map((data) => ChatRoomModel.fromJson(data))
          .toList();

      _chatRoom.insertAll(0, chatRoomList);
      _totalPage = totalPage;

      notifyListeners();
    });
  }
}
import 'package:image_picker/image_picker.dart';
import 'package:packup/model/chat/chat_message_model.dart';
import 'package:packup/model/common/file_model.dart';
import 'package:packup/service/chat/chat_service.dart';

import 'package:packup/model/common/page_model.dart';

import 'package:packup/provider/common/loading_provider.dart';

import 'package:packup/service/common/loading_service.dart';

class ChatMessageProvider extends LoadingProvider {

  final ChatService chatService = ChatService();

  late ChatMessageModel chatMessageModel;
  List<ChatMessageModel> _chatMessage = [];
  int _totalPage = 1;
  int _curPage = 0;

  List<ChatMessageModel> get chatMessage => _chatMessage;
  int get totalPage => _totalPage;
  int get curPage => _curPage;

  // 메시지 로딩
  Future<void> getMessage(int chatRoomSeq) async {
    if (_totalPage < _curPage) return;

    await LoadingService.run(() async {
      final response = await chatService.getMessage(chatRoomSeq, _curPage);
      PageModel pageModel = PageModel.fromJson(response.response);

      List<ChatMessageModel> messageList = pageModel.objectList
          .map((data) => ChatMessageModel.fromJson(data))
          .toList();

      _chatMessage.addAll(messageList);
      _totalPage = pageModel.totalPage;

      _curPage++;

      notifyListeners();
    });
  }

  Future<void> addMessage(ChatMessageModel message) async {

    await LoadingService.run(() async {
      bool exists = _chatMessage.any((msg) => msg.seq == message.seq);
      if (!exists) {
        _chatMessage.insert(0, message);
        notifyListeners();
      }
    });
  }

  Future<FileModel> sendFile(XFile file) async {

    return await LoadingService.run(() async {
      final response = await chatService.sendFile(file);
      return FileModel.fromJson(response.response);

    });
  }
}
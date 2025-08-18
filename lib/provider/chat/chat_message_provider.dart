import 'package:image_picker/image_picker.dart';
import 'package:packup/model/chat/chat_message_model.dart';
import 'package:packup/model/chat/chat_read_model.dart';
import 'package:packup/model/common/file_model.dart';
import 'package:packup/service/chat/chat_service.dart';

import 'package:packup/model/common/page_model.dart';

import 'package:packup/provider/common/loading_provider.dart';

import 'package:packup/service/common/loading_service.dart';

import 'package:packup/service/common/socket_service.dart';

class ChatMessageProvider extends LoadingProvider {

  final ChatService _chatService = ChatService();
  final SocketService _socketService = SocketService();

  List<ChatMessageModel> _chatMessage = [];
  int _totalPage = 1;
  int _curPage = 0;

  List<ChatMessageModel> get chatMessage => _chatMessage;
  int get totalPage => _totalPage;
  int get curPage => _curPage;

  int _lastReadMessageSeq = 0;
  int? get lastReadMessageSeq => _lastReadMessageSeq;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 메시지 로딩
  Future<void> getMessage(int chatRoomSeq) async {
    if (_totalPage <= _curPage) return;

    _isLoading = true;

    // await LoadingService.run(() async {
      final response = await _chatService.getMessage(chatRoomSeq, _curPage);
      final page = PageModel<ChatMessageModel>.fromJson(response.response,
            (e) => ChatMessageModel.fromJson(e),
      );

      _chatMessage.addAll(page.objectList);
      _totalPage = page.totalPage;

      _curPage++;

    _isLoading = false;

      notifyListeners();
    // });
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
      final response = await _chatService.sendFile(file);
      return FileModel.fromJson(response.response);
    });
  }

  void subscribeChatMessage(int chatRoomSeq) {
    final destination = '/topic/chat/room/$chatRoomSeq';

    _socketService.registerCallback(destination, (data) {});

    _socketService.subscribe(destination, (data) {
      final newChatMessage = ChatMessageModel.fromJson(data);
      addMessage(newChatMessage);
    });
  }


  void unSubscribeChatMessage(int chatRoomSeq) {
    final destination = '/topic/chat/room/$chatRoomSeq';

    _socketService.unsubscribe(destination);
    _socketService.unregisterCallback(destination);
  }

  void sendChatMessage(ChatMessageModel newChatMessage) {
    _socketService.sendMessage('/send.message', newChatMessage);
  }


  void readChatMessage(ChatReadModel chatReadModel) {
    _socketService.sendMessage('/read.message', chatReadModel);

    _lastReadMessageSeq = chatReadModel.lastReadMessageSeq!;

    notifyListeners();
  }
}
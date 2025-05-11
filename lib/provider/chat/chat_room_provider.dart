import 'package:packup/model/common/page_model.dart';
import 'package:packup/service/chat/chat_service.dart';

import 'package:packup/model/chat/ChatRoomModel.dart';
import 'package:packup/provider/common/loading_provider.dart';

import 'package:packup/service/common/loading_service.dart';

class ChatRoomProvider extends LoadingProvider {

  final ChatService chatService = ChatService();

  List<ChatRoomModel> _chatRoom = [];
  int _totalPage = 0;
  int _curPage = 0;

  List<ChatRoomModel> get chatRoom => _chatRoom;
  int get totalPage => _totalPage;
  int get curPage => _curPage;

  // 채팅방 리스트
  getRoom(int page) async {
    if(_totalPage < _curPage) return;

    await LoadingService.run(() async {
      final response = await chatService.getRoom(_curPage);
      PageModel pageModel = PageModel.fromJson(response.response);

      final responseList = pageModel.objectList;
      int totalPage  = pageModel.totalPage;

      List<ChatRoomModel> chatRoomList = responseList
          .map((data) => ChatRoomModel.fromJson(data))
          .toList();

      _chatRoom.addAll(chatRoomList);
      _totalPage = totalPage;

      _curPage++;

      notifyListeners();
    });
  }

  void updateFirstChatRoom(ChatRoomModel chatRoomModel) {
    // 이미 있는 채팅방인지 확인
    int existingIndex = _chatRoom.indexWhere((room) => room.seq == chatRoomModel.seq);

    if (existingIndex != -1) {
      _chatRoom.removeAt(existingIndex);
    }

    _chatRoom.insert(0, chatRoomModel);

    notifyListeners();
  }

}
import 'package:packup/model/common/page_model.dart';
import 'package:packup/service/chat/chat_service.dart';

import 'package:packup/model/chat/chat_room_model.dart';
import 'package:packup/provider/common/loading_provider.dart';

import 'package:packup/service/common/loading_service.dart';

import 'package:packup/service/common/socket_service.dart';

class ChatRoomProvider extends LoadingProvider {

  final ChatService _chatService = ChatService();
  final SocketService _socketService = SocketService();

  List<ChatRoomModel> _chatRoom = [];
  int _totalPage = 0;
  int _curPage = 0;

  List<ChatRoomModel> get chatRoom => _chatRoom;
  int get totalPage => _totalPage;
  int get curPage => _curPage;

  final String _lastMessage = '';
  String get lastMessage => _lastMessage;

  // 채팅방 리스트
  getRoom() async {
    if(_totalPage < _curPage) return;

    await LoadingService.run(() async {
      final response = await _chatService.getRoom(_curPage);
      final page = PageModel<ChatRoomModel>.fromJson(response.response,
            (e) => ChatRoomModel.fromJson(e),
      );

      _chatRoom.addAll(page.objectList);
      _totalPage = totalPage;

      _curPage++;

      notifyListeners();
    });
  }

  void updateFirstChatRoom(ChatRoomModel chatRoomModel) {
    print("여기????");
    // 이미 있는 채팅방인지 확인
    int existingIndex = _chatRoom.indexWhere((room) => room.seq == chatRoomModel.seq);

    if (existingIndex != -1) {
      _chatRoom.removeAt(existingIndex);
    }

    _chatRoom.insert(0, chatRoomModel);

    notifyListeners();
  }

  subscribeChatRoom() async {
    print("여기는?");
    const destination = '/user/queue/chatroom-refresh';

    _socketService.registerCallback(destination, (data) {});

    _socketService.subscribe(destination, (data) {
      print("좀 와랴ㅏ");
      final newFirstChatRoom = ChatRoomModel.fromJson(data);
      updateFirstChatRoom(newFirstChatRoom);
    });
  }

  void unSubscribeChatRoom() {
    final destination = '/user/queue/chatroom-refresh';

    _socketService.unsubscribe(destination);
    _socketService.unregisterCallback(destination);
  }

  // 채팅 방 진입시 읽음 처리 > 상태만 바꿀 함수
  void readMessageThisRoom(int chatRoomSeq) {
    final index = _chatRoom.indexWhere((room) => room.seq == chatRoomSeq);
    if (index != -1 && _chatRoom[index].unReadCount! > 0) {
      _chatRoom[index].unReadCount = 0;

      notifyListeners();
    } 
  }
}
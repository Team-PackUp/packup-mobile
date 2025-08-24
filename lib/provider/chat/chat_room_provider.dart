import 'package:packup/model/common/page_model.dart';
import 'package:packup/service/chat/chat_service.dart';
import 'package:packup/model/chat/chat_room_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/common/socket_service.dart';

import '../../Common/util.dart';

class ChatRoomProvider extends LoadingProvider {
  final ChatService _chatService = ChatService();
  final SocketService _socketService = SocketService();

  int? _mySeq;
  Future<int> _ensureMySeq() async {
    final seq = await decodeTokenInfo();
    _mySeq = seq;
    return seq;
  }

  int? _extractUserSeq(ChatRoomModel e) {
    return e.user?.userId;
  }

  // 원본/표시 리스트 분리
  final List<ChatRoomModel> _allChatRooms = [];
  List<ChatRoomModel> _chatRoom = [];

  int _totalPage = 0;
  int _curPage = 0;

  List<ChatRoomModel> get chatRoom => _chatRoom;
  int get totalPage => _totalPage;
  int get curPage => _curPage;

  final String _lastMessage = '';
  String get lastMessage => _lastMessage;

  // 0=전체, 1=안읽은, 2=내가 가이드
  int _activeFilterIdx = 0;
  int get activeFilterIdx => _activeFilterIdx;

  Future<void> getRoom() async {
    if (_totalPage != 0 && _curPage >= _totalPage) return;

    await LoadingService.run(() async {
      final response = await _chatService.getRoom(_curPage);
      final page = PageModel<ChatRoomModel>.fromJson(
        response.response,
            (e) => ChatRoomModel.fromJson(e),
      );

      _allChatRooms.addAll(page.objectList);

      _totalPage = page.totalPage;
      _curPage++;

      await _applyFilter();
    });
  }

  Future<void> _applyFilter() async {
    if (_activeFilterIdx == 2 && _mySeq == null) {
      await _ensureMySeq();
    }
    _applyFilterSync();
  }

  void _applyFilterSync() {
    Iterable<ChatRoomModel> base = _allChatRooms;

    switch (_activeFilterIdx) {
      case 1: // 안읽은
        base = base.where((e) => (e.unReadCount ?? 0) > 0);
        break;

      case 2: // 내가 가이드
        base = base.where((e) => _extractUserSeq(e) == _mySeq);
        break;

      case 0: // 전체
      default:
        base = _allChatRooms;
        break;
    }
    _chatRoom = List<ChatRoomModel>.unmodifiable(base.toList());
    notifyListeners();
  }

  Future<void> filterChatRoom(int idx) async {
    _activeFilterIdx = idx;
    await _applyFilter();
  }

  void updateFirstChatRoom(ChatRoomModel incoming) {
    final i = _allChatRooms.indexWhere((r) => r.seq == incoming.seq);

    if (i != -1) {
      final prev = _allChatRooms[i];

      prev.lastMessage = incoming.lastMessage;
      prev.lastMessageDate = incoming.lastMessageDate;
      prev.unReadCount = incoming.unReadCount;
      prev.fileFlag = incoming.fileFlag;

      _allChatRooms
        ..removeAt(i)
        ..insert(0, prev);
    } else {
      _allChatRooms.insert(0, incoming);
    }

    _applyFilterSync();
  }

  /// 소켓 구독
  Future<void> subscribeChatRoom() async {
    const destination = '/user/queue/chatroom-refresh';
    _socketService.registerCallback(destination, (data) {});
    _socketService.subscribe(destination, (data) {
      final newFirstChatRoom = ChatRoomModel.fromJson(data);
      updateFirstChatRoom(newFirstChatRoom);
    });
  }

  void unSubscribeChatRoom() {
    const destination = '/user/queue/chatroom-refresh';
    _socketService.unsubscribe(destination);
    _socketService.unregisterCallback(destination);
  }

  /// 채팅 방 진입 시 읽음 처리(상태만 변경)
  void readMessageThisRoom(int chatRoomSeq) {
    final idx = _allChatRooms.indexWhere((room) => room.seq == chatRoomSeq);
    if (idx != -1 && (_allChatRooms[idx].unReadCount ?? 0) > 0) {
      _allChatRooms[idx].unReadCount = 0;
      _applyFilterSync();
    }
  }

  /// 목록 초기화
  void clearChatRooms() {
    _allChatRooms.clear();
    _chatRoom = const [];
    _totalPage = 0;
    _curPage = 0;
    _activeFilterIdx = 0;
    _mySeq = null;
    notifyListeners();
  }
}

extension Delta on ChatRoomProvider {
  Future<void> refreshFirstPage() async {
    final resp = await _chatService.getRoom(0);
    final page = PageModel<ChatRoomModel>.fromJson(
      resp.response, (e) => ChatRoomModel.fromJson(e),
    );

    _allChatRooms
      ..removeWhere((_) => true)
      ..addAll(page.objectList);
    _totalPage = page.totalPage;
    _curPage   = 1;

    _applyFilterSync();
  }
}


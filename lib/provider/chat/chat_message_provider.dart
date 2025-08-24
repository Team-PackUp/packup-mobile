import 'package:image_picker/image_picker.dart';
import 'package:packup/model/chat/chat_message_model.dart';
import 'package:packup/model/chat/chat_read_model.dart';
import 'package:packup/model/common/file_model.dart';
import 'package:packup/model/common/page_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/chat/chat_service.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/common/socket_service.dart';

class ChatMessageProvider extends LoadingProvider {
  final ChatService _chatService = ChatService();
  final SocketService _socketService = SocketService();

  final List<ChatMessageModel> _chatMessage = <ChatMessageModel>[];
  int _totalPage = 1;
  int _curPage = 0;

  // 구독 상태
  String? _currentDest;
  bool _isSubscribed = false;
  bool _subscribing = false;

  bool _isLoading = false;

  // 읽음 상태 (로컬 캐시)
  int _lastReadMessageSeq = 0;

  List<ChatMessageModel> get chatMessage => _chatMessage;
  int get totalPage => _totalPage;
  int get curPage => _curPage;
  bool get isLoading => _isLoading;
  int get lastReadMessageSeq => _lastReadMessageSeq;

  void _sortDesc() {
    _chatMessage.sort((a, b) {
      final as = a.seq!, bs = b.seq!;
      return bs.compareTo(as);
    });
  }

  void _mergeUnique(Iterable<ChatMessageModel> list) {
    final existing = _chatMessage.map((e) => e.seq).toSet();
    final seen = <int?>{};
    for (final m in list) {
      final id = m.seq;
      if (id != null && (existing.contains(id) || seen.contains(id))) {
        continue;
      }
      _chatMessage.add(m);
      if (id != null) seen.add(id);
    }
    _sortDesc();
  }

  void _insertAssumingMostlyNewest(ChatMessageModel m) {
    if (_chatMessage.isEmpty) { _chatMessage.add(m); return; }
    final firstSeq = _chatMessage.first.seq ?? -1;
    final newSeq   = m.seq ?? -1;
    if (newSeq > firstSeq) {
      _chatMessage.insert(0, m);
    } else {
      _mergeUnique([m]);
    }
  }

  void _onSocketMessage(dynamic data) {
    final msg = ChatMessageModel.fromJson(data);
    _insertAssumingMostlyNewest(msg);
    notifyListeners();
  }

  Future<void> subscribeChatMessage(int chatRoomSeq) async {
    final dest = '/topic/chat/room/$chatRoomSeq';
    if (_subscribing) return;
    _subscribing = true;
    try {
      if (_isSubscribed && _currentDest == dest) {
        return;
      }
      if (_isSubscribed && _currentDest != null) {
        _socketService.unsubscribe(_currentDest!);
        _socketService.unregisterCallback(_currentDest!);
        _isSubscribed = false;
      }
      _socketService.registerCallback(dest, _onSocketMessage);
      _socketService.subscribe(dest, _onSocketMessage);
      _currentDest = dest;
      _isSubscribed = true;
    } finally {
      _subscribing = false;
    }
  }

  void unSubscribeChatMessage(int chatRoomSeq) {
    final dest = '/topic/chat/room/$chatRoomSeq';
    if (_isSubscribed && _currentDest == dest) {
      _socketService.unsubscribe(dest);
      _socketService.unregisterCallback(dest);
      _isSubscribed = false;
      _currentDest = null;
    }
  }

  bool _refreshing = false;

  Future<void> refreshFirstMessage({required int chatRoomSeq}) async {
    if (_refreshing) return;
    _refreshing = true;
    try {
      await LoadingService.run(() async {
        final resp = await _chatService.getMessage(chatRoomSeq, 0);
        final page = PageModel<ChatMessageModel>.fromJson(
          resp.response, (e) => ChatMessageModel.fromJson(e),
        );
        _mergeUnique(page.objectList);
        _totalPage = page.totalPage;
        _curPage   = 1;
        notifyListeners();
      });
    } finally {
      _refreshing = false;
    }
  }

  Future<void> getMessage(int chatRoomSeq) async {
    if (_refreshing || _isLoading || _curPage >= _totalPage) return;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _chatService.getMessage(chatRoomSeq, _curPage);
      final page = PageModel<ChatMessageModel>.fromJson(
        response.response,
            (e) => ChatMessageModel.fromJson(e),
      );
      _mergeUnique(page.objectList);
      _totalPage = page.totalPage;
      _curPage++;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<FileModel> sendFile(XFile file) async {
    return await LoadingService.run(() async {
      final response = await _chatService.sendFile(file);
      return FileModel.fromJson(response.response);
    });
  }

  void sendChatMessage(ChatMessageModel newChatMessage) {
    _socketService.sendMessage('/send.message', newChatMessage);

    // 낙관적 업데이트
    // _mergeUnique([newChatMessage]);
    // notifyListeners();
  }

  void readChatMessage(ChatReadModel chatReadModel) {
    final seq = chatReadModel.lastReadMessageSeq ?? 0;
    if (seq <= _lastReadMessageSeq) return;

    _socketService.sendMessage('/read.message', chatReadModel);
    _lastReadMessageSeq = seq;
    notifyListeners();
  }

  void clear() {
    _chatMessage.clear();
    _totalPage = 1;
    _curPage = 0;
    _lastReadMessageSeq = 0;
    notifyListeners();
  }
}

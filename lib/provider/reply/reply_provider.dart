import 'package:packup/model/common/page_model.dart';
import 'package:packup/model/reply/reply_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/reply/reply_service.dart';

class ReplyProvider extends LoadingProvider {
  final ReplyService _service = ReplyService();

  final int? targetSeq;
  final TargetType? targetType;

  final int? replySeq;

  late List<ReplyModel> _replyList;

  // 리스트 OR 신규 작성 페이지
  ReplyProvider.create({
    required this.targetSeq,
    required this.targetType,
  }) : replySeq = null, _replyList = [];

  // 수정 페이지
  ReplyProvider.update({
    required this.replySeq,
  })  : targetSeq = null,
        targetType = null;

  ReplyModel? _currentReply;

  int _totalPage = 1;
  int _curPage = 0;

  List<ReplyModel> get replyList => _replyList;
  ReplyModel? get currentReply   => _currentReply;
  int get totalPage              => _totalPage;
  int get curPage                => _curPage;

  Future<void> getReplyList({bool reset = false}) async {

    if (_totalPage <= _curPage) return;

    await LoadingService.run(() async {

      // function 함수로 옮겨야 됨
      final reply = ReplyModel(
          targetSeq: targetSeq!,
          targetType: targetType!,
      );

      final response = await _service.getReplyList(
        _curPage,
        replyModel: reply,
      );

      final page = PageModel.fromJson(response.response);
      print(page.objectList);
      final replList = page.objectList
          .map((e) => ReplyModel.fromJson(e))
          .toList();

      _replyList.addAll(replList);
      _curPage++;
      _totalPage = page.totalPage;

      notifyListeners();
    });
  }

  Future<void> getReply(int seq) async {
    await LoadingService.run(() async {
      final res = await _service.getReply(seq);
      _currentReply = ReplyModel.fromJson(res.response);
      notifyListeners();
    });
  }

  Future<void> upsertReply(String content) async {
    await LoadingService.run(() async {
      if (replySeq != null) {
        // 수정
        await _service.updateReply(seq: replySeq!, content: content);
      } else {
        // 작성
        await _service.saveReply(
          targetSeq : targetSeq!,
          targetType: targetType!.code,
          content   : content,
        );
      }
    });
  }

  Future<void> deleteReply() async {
    await LoadingService.run(() async {
      await _service.deleteReply(replySeq!);
    });
  }
}

import 'package:packup/model/common/page_model.dart';
import 'package:packup/model/reply/reply_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/reply/reply_service.dart';

class ReplyProvider extends LoadingProvider {
  final ReplyService _service = ReplyService();

  final int? targetSeq;
  final TargetType? targetType;

  final int? seq;

  late List<ReplyModel> _replyList;

  // 리스트 OR 신규 작성 페이지
  ReplyProvider.create({
    required this.targetSeq,
    required this.targetType,
  }) : seq = null, _replyList = [];

  // 수정 페이지
  ReplyProvider.update({
    required this.seq,
  })  : targetSeq = null,
        targetType = null;

  ReplyModel? replyModel;

  int _totalPage = 1;
  int _curPage = 0;

  List<ReplyModel> get replyList => _replyList;
  ReplyModel? get currentReply   => replyModel;
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
      final response = await _service.getReply(seq: seq);
      replyModel = ReplyModel.fromJson(response.response);

      notifyListeners();
    });
  }

  Future<void> upsertReply(String content) async {
    await LoadingService.run(() async {
      if (seq != null) {
        // 수정
        final reply = ReplyModel(
            content: content
        );
        await _service.updateReply(seq: seq!, replyModel: reply);
      } else {
        // 작성
        final reply = ReplyModel(
            targetSeq: targetSeq,
            targetType: targetType,
            content   : content,
        );

        await _service.saveReply(replyModel: reply);
      }
    });
  }

  Future<void> deleteReply() async {
    await LoadingService.run(() async {
      await _service.deleteReply(seq: seq!);
    });
  }
}

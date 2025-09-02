import 'package:flutter/cupertino.dart';
import 'package:packup/model/common/page_model.dart';
import 'package:packup/model/reply/reply_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/reply/reply_service.dart';
import 'package:path/path.dart';

import '../../model/common/fcm_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool _isLoading = false;

  List<ReplyModel> get replyList => _replyList;
  ReplyModel? get currentReply   => replyModel;
  int get totalPage              => _totalPage;
  int get curPage                => _curPage;

  Future<void> getReplyList({bool reset = false}) async {
    if (_isLoading) return;
    if (!reset && _totalPage <= _curPage) return;

    _isLoading = true;

    if (reset) {
      _replyList = [];
      _curPage = 0;
      _totalPage = 1;
    }

    await LoadingService.run(() async {
      final reply = ReplyModel(
        targetSeq: targetSeq!,
        targetType: targetType!,
      );

      final response = await _service.getReplyList(_curPage, replyModel: reply);

      final page = PageModel<ReplyModel>.fromJson(
        response.response,
            (e) => ReplyModel.fromJson(e),
      );

      _replyList.addAll(page.objectList);
      _curPage++;
      _totalPage = page.totalPage;

      notifyListeners();
    });

    _isLoading = false;
  }



  Future<void> getReply(int seq) async {
    await LoadingService.run(() async {
      final response = await _service.getReply(seq: seq);
      replyModel = ReplyModel.fromJson(response.response);

      notifyListeners();
    });
  }

  Future<void> upsertReply(BuildContext context, String content, int point) async {
    String message = "리뷰가 등록 되었습니다!";

    if(seq != null) {
      message = "리뷰가 수정 되었습니다!";
    }
    await LoadingService.runHandled(context, () async {
      if (seq != null) {
        // 수정
        final reply = ReplyModel(
            content: content,
            point: point,
        );
        await _service.updateReply(seq: seq!, replyModel: reply);


      } else {
        // 작성
        final reply = ReplyModel(
            targetSeq: targetSeq,
            targetType: targetType,
            content   : content,
            point   : point,
        );

        await _service.saveReply(replyModel: reply);
      }
    }, successMessage: message);

    notifyListeners();
  }

  Future<void> deleteReply() async {
    await LoadingService.run(() async {
      await _service.deleteReply(seq: seq!);
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/model/common/page_model.dart';
import 'package:packup/model/reply/reply_model.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/reply/reply_service.dart';

class ReplyProvider extends ChangeNotifier {
  final ReplyService _service = ReplyService();

  int? targetSeq;
  TargetType? targetType;
  int? replySeq;
  bool editModeFlag = false;

  List<ReplyModel> _replyList = [];
  ReplyModel? replyModel;

  int _totalPage = 1;
  int _curPage = 0;
  int _totalElement = 0;
  bool _isLoading = false;

  List<ReplyModel> get replyList => _replyList;
  ReplyModel? get currentReply   => replyModel;
  int get totalPage              => _totalPage;
  int get curPage                => _curPage;
  int get totalElement           => _totalElement;
  bool get isLoading             => _isLoading;

  void setEditMode({required int seq}) {
    replySeq = seq;
    editModeFlag = true;
  }

  void setTarget({required int targetSeq, required TargetType targetType}) {
    this.targetSeq  = targetSeq;
    this.targetType = targetType;
  }

  Future<void> getReplyList({
    bool reset = false,
    required int targetSeq,
    required TargetType targetType,
  }) async {
    if (_isLoading) return;
    if (!reset && _totalPage <= _curPage) return;
    _isLoading = true;

    if (reset) {
      _replyList = [];
      _curPage = 0;
      _totalPage = 1;
      notifyListeners();
    }
    // await LoadingService.run(() async {
      final reply = ReplyModel(
        targetSeq : targetSeq,
        targetType: targetType,
      );

      final response = await _service.getReplyList(_curPage, replyModel: reply);
      final page = PageModel<ReplyModel>.fromJson(
        response.response,
            (e) => ReplyModel.fromJson(e),
      );

      _replyList.addAll(page.objectList);
      _curPage++;
      _totalPage    = page.totalPage;
      _totalElement = page.totalElement;
    // });

    _isLoading = false;

    notifyListeners();

  }

  Future<void> getReply(int seq) async {
    await LoadingService.run(() async {
      final response = await _service.getReply(seq: seq);
      replyModel = ReplyModel.fromJson(response.response);
      notifyListeners();
    });
  }

  Future<void> upsertReply(BuildContext context, String content, int point, List<XFile> photos) async {
    String message = (editModeFlag) ? "리뷰가 수정 되었습니다!" : "리뷰가 등록 되었습니다!";

    // 첨부 이미지가 있는 경우 먼저 저장
    if(photos.isNotEmpty) {
      await _service.saveImage(photos: photos);
    }

    await LoadingService.runHandled(context, () async {
      if (replySeq != null) {
        // 수정
        final reply = ReplyModel(content: content, point: point);
        await _service.updateReply(seq: replySeq!, replyModel: reply);
      } else {
        // 작성
        final reply = ReplyModel(
          targetSeq : targetSeq,
          targetType: targetType,
          content   : content,
          point     : point,
        );
        await _service.saveReply(replyModel: reply);
      }
    }, successMessage: message);

    notifyListeners();
  }

  Future<void> deleteReply() async {
    await LoadingService.run(() async {
      await _service.deleteReply(seq: replySeq!);
    });
  }
}

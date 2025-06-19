import 'package:packup/model/common/page_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';

import 'package:packup/service/reply/reply_service.dart';

import '../../model/reply/reply_model.dart';

class ReplyProvider extends LoadingProvider {

  final replyService = ReplyService();

  late List<ReplyModel> _replyList;

  ReplyProvider() {
    _replyList = [];
  }

  int _totalPage = 1;
  int _curPage = 0;

  List<ReplyModel> get replyList => _replyList;
  int get totalPage => _totalPage;
  int get curPage => _curPage;

  // 댓글 리스트
  getReplyList() async {
    if (_totalPage < _curPage) return;

    await LoadingService.run(() async {
      final response = await replyService.getReplyList(_curPage);
      PageModel pageModel = PageModel.fromJson(response.response);

      List<ReplyModel> replyList = pageModel.objectList
          .map((data) => ReplyModel.fromJson(data))
          .toList();

      _replyList.addAll(replyList);
      _totalPage = pageModel.totalPage;

      _curPage++;

      notifyListeners();
    });
  }
}
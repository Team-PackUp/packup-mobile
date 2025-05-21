import 'package:packup/model/common/page_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/notice/notice_service.dart';

import 'package:packup/model/notice/notice_model.dart';

class NoticeProvider extends LoadingProvider {

  final noticeService = NoticeService();

  late NoticeModel noticeModel;
  late List<NoticeModel> _noticeList;

  NoticeProvider() {
    noticeModel = NoticeModel.empty();
    _noticeList = [];
  }

  int _totalPage = 1;
  int _curPage = 0;

  List<NoticeModel> get noticeList => _noticeList;
  int get totalPage => _totalPage;
  int get curPage => _curPage;

  // 공지 리스트
  getNoticeList() async {
    if (_totalPage < _curPage) return;

    await LoadingService.run(() async {
      final response = await noticeService.getNoticeList(_curPage);
      PageModel pageModel = PageModel.fromJson(response.response);

      List<NoticeModel> noticeList = pageModel.objectList
          .map((data) => NoticeModel.fromJson(data))
          .toList();

      _noticeList.addAll(noticeList);
      _totalPage = pageModel.totalPage;

      _curPage++;

      notifyListeners();
    });
  }

  // 공지 상세 보기
  getNoticeView(int noticeSeq) async {

    // await LoadingService.run(() async {

      final response = await noticeService.getNoticeView(noticeSeq);
      noticeModel =  NoticeModel.fromJson(response.response);
    // });

    notifyListeners();
  }

}
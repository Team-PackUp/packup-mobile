import 'package:packup/model/common/page_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';

import '../../../model/profile/notice/notice_model.dart';
import '../../../service/profile/notice/notice_service.dart';

class NoticeProvider extends LoadingProvider {

  final noticeService = NoticeService();

  late NoticeModel noticeModel;
  late List<NoticeModel> _noticeList;
  bool _isLoading = false;

  NoticeProvider() {
    noticeModel = NoticeModel.empty();
    _noticeList = [];
  }

  int _totalPage = 1;
  int _curPage = 0;

  List<NoticeModel> get noticeList => _noticeList;
  int get totalPage => _totalPage;
  int get curPage => _curPage;
  bool get isFetching => _isLoading;

  // 공지 리스트
  getNoticeList() async {
    if (_totalPage < _curPage) return;

    _isLoading = true;
    await LoadingService.run(() async {
      final response = await noticeService.getNoticeList(_curPage);
      final page = PageModel<NoticeModel>.fromJson(response.response,
            (e) => NoticeModel.fromJson(e),
      );

      _noticeList.addAll(page.objectList);
      _totalPage = page.totalPage;

      _curPage++;
      _isLoading = false;

      notifyListeners();
    });
  }

  // 공지 상세 보기
  getNoticeView(int noticeSeq) async {
    try {
      _isLoading = true;

      await LoadingService.run(() async {

        final response = await noticeService.getNoticeView(noticeSeq);
        noticeModel =  NoticeModel.fromJson(response.response);
      });
    } catch (e, stack) {
      print('error');
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}
import 'package:flutter_quill/flutter_quill.dart';
import 'package:packup/model/common/page_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/notice/notice_service.dart';

import '../../model/notice/notice_model.dart';
import '../../service/common/quill_view_service.dart';

class NoticeProvider extends LoadingProvider {

  final noticeService = NoticeService();

  NoticeModel noticeModel = NoticeModel.empty();
  List<NoticeModel> _noticeList = [];
  int _totalPage = 1;
  int _curPage = 0;

  List<NoticeModel> get noticeList => _noticeList;
  int get totalPage => _totalPage;
  int get curPage => _curPage;

  late QuillController _quillController;
  QuillController get quillController => _quillController;

  // 공지 리스트
  Future<void> getNoticeList() async {
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

  Future<void> getNoticeView(int noticeSeq) async {
    await LoadingService.run(() async {

      final response = await noticeService.getNoticeView(noticeSeq);
      noticeModel =  NoticeModel.fromJson(response.response);

      QuillViewService().quillInitiate(noticeModel.content!);
      _quillController = QuillViewService().quillController!;
    });


    notifyListeners();
  }

}
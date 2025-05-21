import '../../http/dio_service.dart';
import '../../model/common/result_model.dart';

class NoticeService {

  Future<ResultModel> getNoticeList(int page) async {
    final data = {'page' : page};
    return await DioService().getRequest('/notice/list', data);
  }

  Future<ResultModel> getNoticeView(int noticeSeq) async {
    return await DioService().getRequest('/notice/view/$noticeSeq');
  }
}
import '../../../http/dio_service.dart';
import '../../../model/common/result_model.dart';

class NoticeService {

  static final NoticeService _instance = NoticeService._internal();

  // 객체 생성 방지
  NoticeService._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory NoticeService() {
    return _instance;
  }

  Future<ResultModel> getNoticeList(int page) async {
    final data = {'page' : page};
    return await DioService().getRequest('/notice/list', data);
  }

  Future<ResultModel> getNoticeView(int noticeSeq) async {
    return await DioService().getRequest('/notice/view/$noticeSeq');
  }
}
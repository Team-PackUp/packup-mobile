import '../../../http/dio_service.dart';
import '../../../model/common/result_model.dart';

class FaqService {

  static final FaqService _instance = FaqService._internal();

  // 객체 생성 방지
  FaqService._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory FaqService() {
    return _instance;
  }

  Future<ResultModel> getFaqCategory() async {
    return await DioService().getRequest('/faq/category');
  }

  Future<ResultModel> getFaqList() async {
    return await DioService().getRequest('/faq/list');
  }

  Future<ResultModel> getFaqByCategory(String category) async {
    return await DioService().getRequest('/notice/view/$category');
  }
}
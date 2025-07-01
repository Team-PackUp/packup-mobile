

import '../../http/dio_service.dart';
import '../../model/common/result_model.dart';

class AIRecommendService {
  static final AIRecommendService _instance = AIRecommendService._internal();

  // 객체 생성 방지
  AIRecommendService._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory AIRecommendService() {
    return _instance;
  }

  Future<ResultModel> getRecommendList(int count) async {

    final data = {'count' : count};

    return await DioService().getRequest('/tab/recommend', data);
  }
}

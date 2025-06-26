// lib/provider/ai_recommend/ai_recommend_provider.dart
// ----------------------------------------------------
// Provider + 가상 데이터 (Tour)
// ----------------------------------------------------
import 'package:flutter/material.dart';
import 'package:packup/provider/common/loading_provider.dart';

import '../../http/dio_service.dart';
import '../../model/ai_recommend/recommend_tour_model.dart';
import '../../model/ai_recommend/category_model.dart';
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

    return await DioService().getRequest('/recommend/user', data);
  }
}

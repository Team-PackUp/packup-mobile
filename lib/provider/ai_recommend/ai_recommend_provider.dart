// lib/provider/ai_recommend/ai_recommend_provider.dart
// ----------------------------------------------------
// Provider + 가상 데이터 (Tour)
// ----------------------------------------------------
import 'package:flutter/material.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/ai_recommend/ai_recommend_service.dart';

import '../../model/ai_recommend/recommend_tour_model.dart';
import '../../model/ai_recommend/category_model.dart';
import '../../service/common/loading_service.dart';

class AIRecommendProvider extends LoadingProvider {

  final aiRecommendService = AIRecommendService();

  List<RecommendTourModel> tourList = [];
  List<RecommendTourModel> popular = [];
  List<CategoryModel> categories = [];

  Future<void> init() async {
    await LoadingService.run(() async {

      final response = await aiRecommendService.getRecommendList(5);

      final data = response.response as Map<String, dynamic>;

      tourList = (data['tour'] as List? ?? [])
          .map((e) => RecommendTourModel.fromJson(e as Map<String, dynamic>))
          .toList();

      popular = (data['popular'] as List? ?? [])
          .map((e) => RecommendTourModel.fromJson(e as Map<String, dynamic>))
          .toList();

      notifyListeners();
    });
  }

}

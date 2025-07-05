
import 'package:flutter/material.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/ai_recommend/ai_recommend_service.dart';

import '../../model/ai_recommend/recommend_tour_model.dart';
import '../../service/common/loading_service.dart';

class AIRecommendProvider extends LoadingProvider {
  final _service = AIRecommendService();

  List<RecommendTourModel> tourList = [];
  List<RecommendTourModel> popular  = [];

  bool loadingTours    = true;
  bool loadingPopular  = true;

  initTour() async {
    print("알고리즘 추천");
    loadingTours = true;
    notifyListeners();

    await LoadingService.run(() async {
      final res  = await _service.getRecommendTour(5);
      final data = res.response as Map<String, dynamic>;

      tourList = (data['tour'] as List? ?? [])
          .map((e) => RecommendTourModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    loadingTours = false;
    notifyListeners();
  }

  initPopular() async {
    print("랜덤 추천");
    loadingPopular = true;
    notifyListeners();

    await LoadingService.run(() async {
      final res  = await _service.getRecommendPopular(5);
      final data = res.response as Map<String, dynamic>;

      popular = (data['popular'] as List? ?? [])
          .map((e) => RecommendTourModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    loadingPopular = false;
    notifyListeners();
  }
}


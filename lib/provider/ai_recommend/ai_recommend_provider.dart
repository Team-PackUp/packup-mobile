
import 'package:flutter/material.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/ai_recommend/ai_recommend_service.dart';

import '../../model/ai_recommend/recommend_tour_model.dart';
import '../../model/common/page_model.dart';
import '../../service/common/loading_service.dart';

class AIRecommendProvider extends LoadingProvider {
  final _service = AIRecommendService();

  List<RecommendTourModel> tourList = [];
  List<RecommendTourModel> popular  = [];

  bool loadingTours    = true;
  bool loadingPopular  = true;

  int _totalPage = 1;
  int _curPage = 0;

  int get totalPage => _totalPage;
  int get curPage => _curPage;

  Future<void> initTour(int count) async {
    if (_totalPage <= _curPage) return;

    loadingTours = true;
    notifyListeners();

    await LoadingService.run(() async {
      final res  = await _service.getRecommendTour(page: 1, count: count);
      final data = res.response["tour"] as Map<String, dynamic>;

      final page = PageModel<RecommendTourModel>.fromJson(
        data,
            (e) => RecommendTourModel.fromJson(e),
      );

      tourList   = page.objectList;   // ✔ 리스트 그대로
      _totalPage = page.totalPage;
      _curPage   = page.curPage + 1;  // 다음에 불러올 페이지 번호
    });

    loadingTours = false;
    notifyListeners();
  }


  Future<void> getTourMore(int count) async {
    if (_curPage >= _totalPage) return;

    loadingTours = true;
    notifyListeners();

    await LoadingService.run(() async {
      final res  = await _service.getRecommendTour(page: _curPage, count: count);
      final data = res.response["popular"] as Map<String, dynamic>;

      final page = PageModel<RecommendTourModel>.fromJson(
        data,
            (e) => RecommendTourModel.fromJson(e),
      );

      tourList.addAll(page.objectList);
      _curPage = page.curPage + 1;
    });

    loadingTours = false;
    notifyListeners();
  }

  Future<void> initPopular(int count) async {
    if (_totalPage <= _curPage) return;

    loadingPopular = true;
    notifyListeners();

    await LoadingService.run(() async {
      final res  = await _service.getRecommendPopular(page: _curPage, count: count);
      final data = res.response as Map<String, dynamic>;
      print(data);

      final popularPage = PageModel<RecommendTourModel>.fromJson(
        data['popular'] as Map<String, dynamic>,
            (e) => RecommendTourModel.fromJson(e),
      );

      popular = popularPage.objectList;
    });

    loadingPopular = false;
    notifyListeners();
  }

}


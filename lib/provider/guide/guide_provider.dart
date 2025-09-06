import 'package:packup/model/guide/guide_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/guide/guide_service.dart';

import '../../model/common/page_model.dart';
import '../../service/common/loading_service.dart';

class GuideProvider extends LoadingProvider {
  final _service = GuideService();

  late List<GuideModel> _guideList = [];
  late List<GuideModel> _guideListAll = [];
  bool loadingGuide = false;

  get guideList => _guideList;
  get guideListAll => _guideListAll;

  int _totalPage = 1;
  int _curPage = 0;

  int get totalPage => _totalPage;
  int get curPage => _curPage;

  Future<void> getGuideList(int count) async {
    if (_totalPage <= _curPage) return;

    loadingGuide = true;
    notifyListeners();

    await LoadingService.run(() async {
      final response  = await _service.getGuideList(page: _curPage, size: count);
      final page = PageModel<GuideModel>.fromJson(
        response.response,
            (e) => GuideModel.fromJson(e),
      );

      _guideList   = page.objectList;
      _totalPage = page.totalPage;
      _curPage   = page.curPage + 1;
    });

    loadingGuide = false;
    notifyListeners();
  }

}
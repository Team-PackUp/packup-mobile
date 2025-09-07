import 'package:packup/model/guide/guide_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/guide/guide_service.dart';

import '../../model/common/page_model.dart';

class GuideProvider extends LoadingProvider {
  final _service = GuideService();

  List<GuideModel> _guideList = [];
  List<GuideModel> _originalList = [];

  bool loadingGuide = false;

  List<GuideModel> get guideList => _guideList;

  int _totalPage = 1;
  int _curPage = 0;
  bool _nextPageFlag = true;

  int get totalPage => _totalPage;
  int get curPage => _curPage;

  Future<void> getGuideList(int count) async {
    if (_totalPage <= _curPage || !_nextPageFlag) return;

    loadingGuide = true;
    notifyListeners();

    final response = await _service.getGuideList(page: _curPage, size: count);
    final page = PageModel<GuideModel>.fromJson(
      response.response,
          (e) => GuideModel.fromJson(e),
    );

    if (_curPage == 0) {
      _guideList = page.objectList;
      _originalList = List.from(page.objectList);
    } else {
      _guideList.addAll(page.objectList);
      _originalList.addAll(page.objectList);
    }

    _totalPage = page.totalPage;
    _nextPageFlag = page.nextPageFlag;
    if(_nextPageFlag) {
      _curPage = page.curPage + 1;
    }

    loadingGuide = false;
    notifyListeners();
  }

  void filterGuideList(String keyword) {
    if (keyword.isEmpty) {
      _guideList = List.from(_originalList);
    } else {
      _guideList = _originalList.where((guide) {
        final name = guide.user?.nickname ?? '';
        return name.contains(keyword);
      }).toList();
    }
    notifyListeners();
  }
}

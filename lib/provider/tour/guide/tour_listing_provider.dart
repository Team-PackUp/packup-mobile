import 'package:packup/model/common/page_model.dart';
import 'package:packup/model/tour/tour_listing_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/tour/tour_service.dart';

class TourListingProvider extends LoadingProvider {
  final TourService _tourService = TourService();

  final List<TourListingModel> _items = [];
  int _totalPage = 1; // 서버 totalPages
  int _curPage = 0; // 클라이언트가 마지막으로 받은 현재 페이지(1-based). 0 = 아직 없음.

  List<TourListingModel> get items => _items;
  bool get loading => isLoading;
  bool get hasMore => _curPage < _totalPage;

  Future<void> fetchNext() async {
    if (!hasMore || loading) return;

    final nextPage = _curPage + 1;

    await handleLoading(() async {
      final res = await _tourService.getMyListings(page: nextPage, size: 20);

      final page = PageModel<TourListingModel>.fromJson(
        res.response,
        (e) => TourListingModel.fromJson(e),
      );

      _items.addAll(page.objectList);
      _totalPage = page.totalPage;
      _curPage = page.curPage;

      notifyListeners();
    });
  }

  Future<void> refresh() async {
    if (loading) return;
    await handleLoading(() async {
      _items.clear();
      _curPage = 0;
      _totalPage = 1;
      notifyListeners();
      await fetchNext();
    });
  }

  void reset() {
    _items.clear();
    _curPage = 0;
    _totalPage = 1;
    notifyListeners();
  }
}

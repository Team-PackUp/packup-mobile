import 'package:packup/model/common/page_model.dart';
import 'package:packup/model/tour/tour_listing_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/tour/tour_service.dart';

class TourListingProvider extends LoadingProvider {
  final TourService _tourService = TourService();

  final List<TourListingModel> _items = [];
  int _totalPage = 1;
  int _curPage = 0;

  List<TourListingModel> get items => _items;
  bool get loading => isLoading;
  int get totalPage => _totalPage;
  int get curPage => _curPage;

  Future<void> fetchNext() async {
    if (_curPage >= _totalPage) return;

    await handleLoading(() async {
      final res = await _tourService.getMyListings(_curPage);

      final page = PageModel<TourListingModel>.fromJson(
        res.response,
        (e) => TourListingModel.fromJson(e),
      );

      _items.addAll(page.objectList);
      _totalPage = page.totalPage;
      _curPage += 1;

      notifyListeners();
    });
  }

  Future<void> refresh() async {
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

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
  bool get hasMore => _curPage < _totalPage;

  Future<void> fetchNext() async {
    if (!hasMore || loading) return;

    final nextPage = _curPage + 1;

    await handleLoading(() async {
      final res = await _tourService.getMyListings(page: nextPage, size: 20);

      final Map<String, dynamic> raw = Map<String, dynamic>.from(res.response);
      final adapted = <String, dynamic>{
        'objectList': (raw['objectList'] ?? raw['content'] ?? []) as List,
        'curPage': raw['curPage'] ?? raw['page'] ?? 1,
        'totalPage': raw['totalPage'] ?? raw['totalPages'] ?? 1,
      };

      final page = PageModel<TourListingModel>.fromJson(
        adapted,
        (e) => TourListingModel.fromJson(e),
      );

      _items.addAll(page.objectList);
      _totalPage = page.totalPage;
      _curPage = page.curPage;

      notifyListeners();
    });
  }

  Future<void> refresh() async {
    print('refresh called');
    if (loading) return;

    _items.clear();
    _curPage = 0;
    _totalPage = 1;
    notifyListeners();

    await fetchNext();
  }

  // Future<void> refresh() async {
  //   if (loading) return;

  //   await handleLoading(() async {
  //     _items.clear();
  //     _curPage = 0;
  //     _totalPage = 1;
  //     notifyListeners();
  //     await fetchNext();
  //   });
  // }

  void reset() {
    _items.clear();
    _curPage = 0;
    _totalPage = 1;
    notifyListeners();
  }
}

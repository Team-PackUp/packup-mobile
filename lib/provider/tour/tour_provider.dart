import 'package:packup/model/common/page_response.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/tour/tour_service.dart';

class TourProvider extends LoadingProvider {
  final TourService _tourService = TourService();

  List<TourModel> _tourList = [];
  List<TourModel> get tourList => _tourList;

  final int _size = 20;
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool get hasNextPage => _hasNextPage;
  bool _isFetching = false;
  bool get isLoading => _isFetching;

  TourModel? _selectedTour;
  TourModel? get selectedTour => _selectedTour;

  Future<void> getTourList({bool refresh = false}) async {
    if (_isFetching || (!_hasNextPage && !refresh)) return;

    if (refresh) {
      _tourList = [];
      _currentPage = 1;
      _hasNextPage = true;
      notifyListeners(); // UI 반영
    }

    print('[TourProvider] getTourList() 호출됨');
    _isFetching = true;

    await LoadingService.run(() async {
      try {
        final response = await _tourService.getTourList(
          page: _currentPage,
          size: _size,
        );
        final data = response.response;

        final page = PageResponse.fromJson(data, (e) => TourModel.fromJson(e));

        _tourList.addAll(page.content);
        _hasNextPage = !page.last;
        _currentPage++;

        notifyListeners();
      } catch (e, stack) {
        print('[TourProvider] 예외 발생: $e\n$stack');
      } finally {
        _isFetching = false;
      }
    });
  }
}

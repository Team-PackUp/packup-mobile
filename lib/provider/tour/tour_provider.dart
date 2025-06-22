import 'package:packup/model/common/page_response.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/tour/tour_service.dart';

/// 투어 목록 관련 상태를 관리하는 Provider 클래스입니다.
/// 무한 스크롤, 선택된 투어 정보, 로딩 상태 등을 포함합니다.
class TourProvider extends LoadingProvider {
  final TourService _tourService = TourService();

  // 투어 목록
  List<TourModel> _tourList = [];

  /// 현재 불러온 전체 투어 목록
  List<TourModel> get tourList => _tourList;

  // 페이징 관련 변수
  final int _size = 20; // 페이지당 항목 수
  int _currentPage = 1;
  bool _hasNextPage = true;

  /// 다음 페이지가 존재하는지 여부
  bool get hasNextPage => _hasNextPage;

  bool _isFetching = false;

  /// 현재 데이터를 불러오는 중인지 여부 (로딩 상태)
  bool get isLoading => _isFetching;

  // 선택된 투어 (필요시 편집 화면 등에서 활용)
  TourModel? _selectedTour;

  /// 현재 선택된 투어
  TourModel? get selectedTour => _selectedTour;

  /// 투어 목록을 가져옵니다.
  /// [refresh]가 true일 경우, 목록을 초기화하고 첫 페이지부터 다시 요청합니다.
  Future<void> getTourList({bool refresh = false}) async {
    // 중복 호출 방지 또는 마지막 페이지까지 도달한 경우
    if (_isFetching || (!_hasNextPage && !refresh)) return;

    if (refresh) {
      // 새로고침: 상태 초기화
      _tourList = [];
      _currentPage = 1;
      _hasNextPage = true;
      notifyListeners(); // UI 갱신
    }

    print('[TourProvider] getTourList() 호출됨');
    _isFetching = true;

    // 공통 로딩 처리
    await LoadingService.run(() async {
      try {
        // 투어 리스트 API 호출
        final response = await _tourService.getTourList(
          page: _currentPage,
          size: _size,
        );
        final data = response.response;

        // 페이지 응답 파싱
        final page = PageResponse.fromJson(data, (e) => TourModel.fromJson(e));

        // 응답 데이터 누적
        _tourList.addAll(page.content);
        _hasNextPage = !page.last;
        _currentPage++;

        notifyListeners(); // UI에 변경 사항 알림
      } catch (e, stack) {
        print('[TourProvider] 예외 발생: $e\n$stack');
      } finally {
        _isFetching = false;
      }
    });
  }
}

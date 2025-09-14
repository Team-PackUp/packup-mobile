import 'package:flutter/cupertino.dart';
import 'package:packup/model/common/page_response.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:packup/model/guide/guide_model.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/tour/tour_service.dart';

import '../../model/tour/tour_detail_model.dart';

/// 투어 목록 관련 상태를 관리하는 Provider 클래스입니다.
/// 무한 스크롤, 선택된 투어 정보, 로딩 상태 등을 포함합니다.
class TourProvider extends ChangeNotifier {
  final TourService _tourService = TourService();

  // 투어 목록
  List<TourModel> _tourList = [];

  // 검색용
  List<TourModel> _originalList = [];

  List<TourModel> _tourListByGuide = [];

  // tour detail
  TourDetailModel? _tour;
  TourDetailModel? get tour => _tour;

  /// 현재 불러온 전체 투어 목록
  List<TourModel> get tourList => _tourList;
  List<TourModel> get tourListByGuide => _tourListByGuide;

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
  Future<void> getTourList({bool refresh = false, String? regionCode}) async {

    // 중복 호출 방지 또는 마지막 페이지까지 도달한 경우
    if (_isFetching || (!_hasNextPage && !refresh)) return;

    if (refresh) {
      // 새로고침: 상태 초기화
      _tourList = [];
      _originalList = [];
      _currentPage = 1;
      _hasNextPage = true;
      notifyListeners(); // UI 갱신
    }

    print('[TourProvider] getTourList() 호출됨');
    _isFetching = true;

    // 공통 로딩 처리
    await LoadingService.run(() async {
      try {

        final ResultModel response;

        if (regionCode != null && regionCode.isNotEmpty) {
          response = await _tourService.getTourListByRegion(
            regionCode: regionCode,
            page: _currentPage,
            size: _size,
          );
        } else {
          response = await _tourService.getTourList(
            page: _currentPage,
            size: _size,
          );
        }

        final data = response.response;

        // 페이지 응답 파싱
        final page = PageResponse.fromJson(data, (e) => TourModel.fromJson(e));

        // 응답 데이터 누적
        _tourList.addAll(page.content);
        _originalList.addAll(_tourList);
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

  void filterTourList(String keyword) {
    if (keyword.isEmpty) {
      _tourList = List.from(_originalList);
    } else {
      _tourList = _originalList.where((tour) {
        final title = tour.tourTitle ?? '';
        final guide = tour.guide?.guideName ?? '';
        return title.contains(keyword) || guide.contains(keyword);
      }).toList();
    }
    notifyListeners();
  }

  // Home 탭에서 사용할 투어 조회 함수
  Future<void> getTourListNoProgress({required String regionCode}) async {

    if (_isFetching) return;

    _isFetching = true;
      try {

        final ResultModel response;

        response = await _tourService.getTourListByRegion(
          regionCode: regionCode,
          page: _currentPage,
          size: _size,
        );

        final data = response.response;

        final page = PageResponse.fromJson(data, (e) => TourModel.fromJson(e));

        _tourList.addAll(page.content);
        _originalList.addAll(_tourList);
        _hasNextPage = !page.last;
        _currentPage++;

        notifyListeners();
      } catch (e, stack) {
        print('[TourProvider] 예외 발생: $e\n$stack');
      } finally {
        _isFetching = false;
      }
  }

  Future<void> getTourListByGuide({required int guideSeq}) async {
    final res = await _tourService.getTourListByGuide(guideSeq: guideSeq);

    final List<dynamic> raw = res.response as List<dynamic>;
    _tourListByGuide = raw
        .map((e) => TourModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    notifyListeners();
  }

  Future<void> getTourDetail({required tourSeq}) async {
    await LoadingService.run(() async {
      final response = await _tourService.getTourDetail(tourSeq: tourSeq);
      _tour = TourDetailModel.fromJson(response.response);
    });

    notifyListeners();
  }
}

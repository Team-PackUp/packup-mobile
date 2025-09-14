import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_session_model.dart';
import 'package:packup/service/tour/tour_service.dart';

import '../../../model/common/page_response.dart';
import '../../../model/common/result_model.dart';
import '../../../model/tour/tour_model.dart';
import '../../../service/common/loading_service.dart';

class ReservationListProvider extends ChangeNotifier {
  final TourService _tourService = TourService();

  List<TourModel> _originalList = [];

  bool _isFetching = false;
  bool get isLoading => _isFetching;

  int _currentPage = 1;
  bool _hasNextPage = true;

  /// 다음 페이지가 존재하는지 여부
  bool get hasNextPage => _hasNextPage;

  // 예약한 투어
  List<TourModel> _bookingTourList = [];
  List<TourModel> get bookingTourList => _bookingTourList;
  int _bookingSize = 20;
  int _bookingCurrentPage = 1;

  Future<void> getBookingTourList({int? size}) async {

    if(size != null) {
      _bookingSize = size;
    }

    _isFetching = true;

    await LoadingService.run(() async {
      try {

        final ResultModel response;

        response = await _tourService.getBookingTourList(
          page: _bookingCurrentPage,
          size: _bookingSize,
        );

        final data = response.response;

        final page = PageResponse.fromJson(data, (e) => TourModel.fromJson(e));

        _bookingTourList.addAll(page.content);
        _originalList.addAll(_bookingTourList);
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

  void filterBookingTourList(String keyword) {
    if (keyword.isEmpty) {
      _bookingTourList = List.from(_originalList);
    } else {
      _bookingTourList = _originalList.where((tour) {
        final title = tour.tourTitle ?? '';
        return title.contains(keyword);
      }).toList();
    }
    notifyListeners();
  }
}

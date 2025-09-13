import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_session_model.dart';
import 'package:packup/service/tour/tour_service.dart';

class ReservationProvider extends ChangeNotifier {
  final TourService _tourService = TourService();

  final int tourSeq;
  final int pricePerPerson;
  final String? tourTitle;

  final bool privateAvailable;
  final int? privateMinPrice;

  ReservationProvider({
    required this.tourSeq,
    required this.pricePerPerson,
    this.tourTitle,
    this.privateAvailable = false,
    this.privateMinPrice,
  });

  List<TourSessionModel> _sessions = [];
  List<TourSessionModel> get sessions => _sessions;

  bool _loading = false;
  bool get loading => _loading;

  TourSessionModel? _selected;
  TourSessionModel? get selected => _selected;

  int _guestCount = 1;
  int get guestCount => _guestCount;

  bool _isPrivate = false;
  bool get isPrivate => _isPrivate;

  /// 프라이빗 기능을 쓸 수 있는지
  bool get supportsPrivate => privateAvailable && (privateMinPrice != null);

  void setPrivate(bool v) {
    if (!supportsPrivate) return;
    if (_isPrivate == v) return;
    _isPrivate = v;
    notifyListeners();
  }

  int get remaining {
    if (_selected == null) return 99;
    final cap = _selected!.capacity ?? 99;
    final booked = _selected!.bookedCount ?? 0;
    final left = cap - booked;
    return left < 0 ? 0 : left;
  }

  int get maxSelectableGuest => remaining.clamp(0, 99);

  /// 프라이빗 미적용 기본 금액
  int get basePrice {
    if (_selected == null) return 0;
    return pricePerPerson * _guestCount;
  }

  /// 프라이빗 최소 요금까지의 부족분 (업셀 문구용)
  int get privateShortfall {
    if (!supportsPrivate) return 0;
    return math.max(0, (privateMinPrice ?? 0) - basePrice);
  }

  /// 실제 결제 금액
  int get totalPrice {
    if (_selected == null) return 0;
    if (_isPrivate && supportsPrivate) {
      return math.max(basePrice, privateMinPrice!);
    }
    return basePrice;
  }

  bool get canProceed => _selected != null && remaining > 0 && _guestCount > 0;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    try {
      _sessions = await _tourService.fetchOpenSessions(
        tourSeq: tourSeq,
        from: DateTime.now(),
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void selectSession(TourSessionModel s) {
    _selected = s;
    if (_guestCount > maxSelectableGuest && maxSelectableGuest > 0) {
      _guestCount = maxSelectableGuest;
    }
    if (maxSelectableGuest == 0) {
      _guestCount = 1;
    }
    notifyListeners();
  }

  void incGuest() {
    if (_guestCount < (maxSelectableGuest == 0 ? 1 : maxSelectableGuest)) {
      _guestCount += 1;
      notifyListeners();
    }
  }

  void decGuest() {
    if (_guestCount > 1) {
      _guestCount -= 1;
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_session_model.dart';
import 'package:packup/service/tour/tour_service.dart';

class ReservationProvider extends ChangeNotifier {
  final TourService _tourService = TourService();

  final int tourSeq;
  final int pricePerPerson;

  ReservationProvider({required this.tourSeq, required this.pricePerPerson});

  List<TourSessionModel> _sessions = [];
  List<TourSessionModel> get sessions => _sessions;

  bool _loading = false;
  bool get loading => _loading;

  TourSessionModel? _selected;
  TourSessionModel? get selected => _selected;

  int _guestCount = 1;
  int get guestCount => _guestCount;

  int get remaining {
    if (_selected == null) return 99;
    final cap = _selected!.capacity ?? 99;
    final booked = _selected!.bookedCount ?? 0;
    final left = cap - booked;
    return left < 0 ? 0 : left;
  }

  int get maxSelectableGuest {
    return remaining.clamp(0, 99);
  }

  int get totalPrice {
    if (_selected == null) return 0;
    return pricePerPerson * _guestCount;
  }

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

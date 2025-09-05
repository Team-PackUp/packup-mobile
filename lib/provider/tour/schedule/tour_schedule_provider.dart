import 'package:flutter/foundation.dart';
import 'package:packup/model/tour/tour_session_model.dart';
import 'package:packup/service/tour/tour_service.dart';

class TourScheduleProvider extends ChangeNotifier {
  final _tourService = TourService();

  List<TourSessionModel> _sessions = [];
  TourSessionModel? _selected;

  List<TourSessionModel> get sessions => _sessions;
  TourSessionModel? get selected => _selected;

  Future<void> load(int tourSeq) async {
    _sessions = await _tourService.fetchSessions(tourSeq);
    notifyListeners();
  }

  void select(TourSessionModel s) {
    if (!s.status.isReservable) return;
    _selected = s;
    notifyListeners();
  }

  void clear() {
    _sessions = [];
    _selected = null;
    notifyListeners();
  }
}

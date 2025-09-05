import 'package:flutter/foundation.dart';
import 'package:packup/model/tour/tour_session_create_request.dart';
import 'package:packup/model/tour/tour_session_model.dart';
import 'package:packup/service/tour/tour_service.dart';

class TourSessionOpenProvider extends ChangeNotifier {
  final _service = TourService();

  int? _tourSeq;
  bool _loading = false;
  Object? _error;

  DateTime _selectedDate = DateTime.now();
  Duration _duration = const Duration(minutes: 60);
  DateTime? _selectedStart;
  List<TourSessionModel> _sessions = [];

  bool get loading => _loading;
  Object? get error => _error;
  DateTime get selectedDate => _selectedDate;
  Duration get duration => _duration;
  DateTime? get selectedStart => _selectedStart;
  DateTime? get selectedEnd =>
      (_selectedStart == null) ? null : _selectedStart!.add(_duration);
  List<TourSessionModel> get sessions => _sessions;

  Future<void> init(int tourSeq) async {
    _tourSeq = tourSeq;
    await refresh();
  }

  Future<void> refresh() async {
    if (_tourSeq == null) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _sessions = await _service.fetchSessions(_tourSeq!);
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setDate(DateTime d) {
    _selectedDate = DateTime(d.year, d.month, d.day);
    if (_selectedStart != null) {
      final t = _selectedStart!;
      _selectedStart = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    }
    notifyListeners();
  }

  void setDuration(Duration d) {
    _duration = d;
    notifyListeners();
  }

  void pickTime(int hour, int minute) {
    _selectedStart = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour,
      minute,
    );
    notifyListeners();
  }

  bool get canSubmit => _tourSeq != null && _selectedStart != null;

  Future<void> submit() async {
    if (!canSubmit) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final req = TourSessionCreateRequest(
        tourSeq: _tourSeq!,
        sessionStartTime: _selectedStart!,
        sessionEndTime: _selectedStart!.add(_duration),
      );
      await _service.createSession(tourSeq: _tourSeq!, req: req);
      await refresh();
      _selectedStart = null;
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

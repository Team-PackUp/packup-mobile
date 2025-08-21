import 'package:flutter/foundation.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:packup/model/guide/guide_intro_model.dart';
import 'package:packup/service/guide/guide_service.dart';

enum IntroStep { years, roleSummary, expertise, achievement, review }

class GuideIntroProvider extends ChangeNotifier {
  final GuideService _service;

  GuideIntroProvider(this._service);

  bool _loading = false;
  bool get loading => _loading;

  bool _dirty = false;
  bool get dirty => _dirty;

  String? _error;
  String? get error => _error;

  IntroStep _step = IntroStep.years;
  IntroStep get step => _step;

  GuideIntroModel _data = GuideIntroModel.empty();
  GuideIntroModel get data => _data;

  Future<void> load() async {
    _setLoading(true);
    _error = null;
    try {
      final ResultModel res = await _service.fetchMyIntro();
      if ((res.resultFlag == true) && res.response != null) {
        _data = GuideIntroModel.fromJson(res.response as Map<String, dynamic>);
      } else {
        _data = GuideIntroModel.empty();
      }
    } catch (e) {
      _error = '가이드 소개 정보를 불러오지 못했습니다.';
    } finally {
      _setLoading(false);
    }
  }

  void setYears(String v) {
    final nv = _sanitizeYears(v);
    _update(_data.copyWith(years: nv));
  }

  void incYears({int min = 0, int max = 50}) {
    final cur = int.tryParse(_data.years.trim()) ?? 0;
    final next = (cur + 1).clamp(min, max);
    _update(_data.copyWith(years: next.toString()));
  }

  void decYears({int min = 0, int max = 50}) {
    final cur = int.tryParse(_data.years.trim()) ?? 0;
    final next = (cur - 1).clamp(min, max);
    _update(_data.copyWith(years: next.toString()));
  }

  void setRoleSummary(String v) => _update(_data.copyWith(roleSummary: v));
  void setExpertise(String v) => _update(_data.copyWith(expertise: v));
  void setAchievement(String v) => _update(_data.copyWith(achievement: v));
  void setSummary(String v) => _update(_data.copyWith(summary: v));

  void next() {
    if (!validateCurrent()) return;
    if (_step == IntroStep.review) return;
    _step = IntroStep.values[_step.index + 1];
    notifyListeners();
  }

  void back() {
    if (_step.index == 0) return;
    _step = IntroStep.values[_step.index - 1];
    notifyListeners();
  }

  void goTo(IntroStep s) {
    _step = s;
    notifyListeners();
  }

  bool validateCurrent() {
    switch (_step) {
      case IntroStep.years:
        return _validYears(_data.years);
      case IntroStep.roleSummary:
        return _nonEmptyMax(_data.roleSummary, 90);
      case IntroStep.expertise:
        return _nonEmptyMax(_data.expertise, 90);
      case IntroStep.achievement:
        return _maxLen(_data.achievement, 90);
      case IntroStep.review:
        return _validYears(_data.years) &&
            _nonEmptyMax(_data.roleSummary, 90) &&
            _nonEmptyMax(_data.expertise, 90) &&
            _maxLen(_data.achievement, 90) &&
            _nonEmptyMax(_data.summary, 90);
    }
  }

  Future<bool> submit() async {
    if (!validateCurrent()) return false;
    _setLoading(true);
    _error = null;
    try {
      final ResultModel res = await _service.upsertIntro(_data);
      final ok = (res.resultFlag == true);
      if (ok) {
        _dirty = false;
        notifyListeners();
        return true;
      } else {
        _error = res.message ?? '저장에 실패했습니다.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = '저장 중 오류가 발생했습니다.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ---- 유틸 ----
  void _update(GuideIntroModel m) {
    _data = m;
    _dirty = true;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  bool _validYears(String s) {
    final n = int.tryParse(s.trim());
    if (n == null) return false;
    return n >= 0 && n <= 50;
  }

  String _sanitizeYears(String s) {
    // 숫자만 허용, 범위 Clamp
    final n = int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return n.clamp(0, 50).toString();
  }

  bool _nonEmptyMax(String s, int max) =>
      s.trim().isNotEmpty && s.length <= max;

  bool _maxLen(String s, int max) => s.length <= max;
}

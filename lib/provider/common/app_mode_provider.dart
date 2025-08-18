import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:packup/model/common/app_mode.dart';

class AppModeProvider extends ChangeNotifier {
  static const _k = 'app_mode';
  AppMode _mode = AppMode.user;
  bool _bootstrapped = false;

  AppMode get mode => _mode;
  bool get ready => _bootstrapped;

  Future<void> load() async {
    _mode = AppMode.user;
    _bootstrapped = true;
    notifyListeners();
  }

  Future<void> setMode(AppMode m) async {
    if (_mode == m) return;
    _mode = m;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_k, m == AppMode.guide ? 'guide' : 'user');
    notifyListeners();
  }

  Future<void> toggle() async =>
      setMode(_mode == AppMode.user ? AppMode.guide : AppMode.user);
}

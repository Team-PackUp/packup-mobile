import 'package:flutter/foundation.dart';

class LoadingProvider extends ChangeNotifier {
  int _pending = 0;                 // 동시에 진행 중인 작업 수
  bool get isLoading => _pending > 0;

  Future<T> handleLoading<T>(Future<T> Function() callback) async {
    _pending++;
    if (_pending == 1) notifyListeners();

    try {
      return await callback();
    } finally {
      _pending--;
      if (_pending == 0) notifyListeners();
    }
  }
}

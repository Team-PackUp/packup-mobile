import 'package:flutter/cupertino.dart';

class LoadingNotifier extends ChangeNotifier  {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<T> handleLoading<T>(Future<T> Function() callBack) async {
    if (_isLoading) return Future.error("이미 로딩 중입니다");
    _isLoading = true;
    notifyListeners();

    try {
      return await callBack();
    } finally {
      print("알림");
      _isLoading = false;
      notifyListeners();
    }
  }
}

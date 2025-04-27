import 'package:flutter/foundation.dart';
import 'package:packup/Common/util.dart';
import 'package:packup/const/const.dart';

class SearchBarProvider with ChangeNotifier {
  String _searchText = '';
  String _apiUrl = '';

  String get searchText => _searchText;
  String get apiUrl => _apiUrl;

  void setSearchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  void setApiUrl(String url) {
    _apiUrl = url;
    notifyListeners();
  }

  Future<void> fetchResults() async {
    logger('URL: $_apiUrl, 입력 텍스트: $_searchText', INFO);
  }
}

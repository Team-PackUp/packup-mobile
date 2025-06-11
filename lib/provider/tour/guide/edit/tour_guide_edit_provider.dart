import 'package:flutter/cupertino.dart';

class TourGuideEditProvider with ChangeNotifier {
  String _name = '';
  String get name => _name;

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }
}

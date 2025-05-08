import 'package:flutter/material.dart';
import 'package:packup/model/user/preference/user_preference_model.dart';
import 'package:packup/service/user/preference_service.dart';

class UserPreferenceProvider extends ChangeNotifier {
  final Set<String> _selected = {};
  final UserService _userService = UserService();

  Set<String> get selected => _selected;

  void togglePreference(String item) {
    if (_selected.contains(item)) {
      _selected.remove(item);
    } else {
      _selected.add(item);
    }
    notifyListeners();
  }

  Future<void> submitPreferences() async {
    final model = UserPreferenceModel(preferCategories: _selected.toList());
    await _userService.updateUserPrefer(model);
  }
}

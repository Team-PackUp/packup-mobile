import 'package:flutter/material.dart';

class ScheduleProvider with ChangeNotifier {

  // 선택한 날짜
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  changeSelectedDate({
    required DateTime date,
  }) async {
    selectedDate = date;
    notifyListeners();
  }
}

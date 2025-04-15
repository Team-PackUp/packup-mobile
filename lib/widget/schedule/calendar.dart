import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/view/schedule/schedule_view_model.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  // final DateTime selectedDate; // 선택한 날짜

  const Calendar({
    super.key,
    // required this.selectedDate,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime focusedDay = DateTime.now();   // 금일
  DateTime selectedDay = DateTime.now();  // 선택

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'en_US',
      onDaySelected: (selectedDay, focusedDay) =>
          onDaySelected(selectedDay, context),
      selectedDayPredicate: (date) => isSameDay(date, selectedDay),
      focusedDay: focusedDay,
      firstDay: DateTime(1800, 1, 1),
      lastDay: DateTime(3000, 1, 1),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
            color: PRIMARY_COLOR
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: PRIMARY_COLOR,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: PRIMARY_COLOR,
        ),
      ),
      calendarStyle: CalendarStyle(
        defaultTextStyle: TextStyle(color: PRIMARY_COLOR),
        weekendTextStyle: TextStyle(color: PRIMARY_COLOR),
        selectedTextStyle: TextStyle(
          color: PRIMARY_COLOR,         // 선택된 날짜의 텍스트 색상
          fontWeight: FontWeight.bold,  // 강조를 위해 굵게 설정
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 2.0, // 테두리 두께 설정
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }


  Future<void> onDaySelected(DateTime selectedDate, BuildContext context) async {
      setState(() {
        selectedDay = selectedDate;
      });

      // final provider = context.read<ScheduleViewModel>();
      // await provider.changeSelectedDate(date: selectedDate);
      // await provider.getSchedules();
    }
}

import 'package:flutter/material.dart';
import 'package:packup/l10n/app_localizations.dart';

import 'package:packup/const/color.dart';

import 'package:packup/widget/schedule/calendar.dart';
import 'package:packup/view/schedule/schedule_view_model.dart';
import 'package:provider/provider.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final paddingTop = MediaQuery.of(context).padding.top;

    final usableHeight = screenHeight - appBarHeight - paddingTop;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: PRIMARY_COLOR,
        title: Text(
          AppLocalizations.of(context)!.login,
          style: TextStyle(color: TEXT_COLOR_W),
        ),
      ),
      body: SafeArea(
        child: Column(
            children: [
              Calendar(),
            ],
          ),
        ),
    );
  }

}




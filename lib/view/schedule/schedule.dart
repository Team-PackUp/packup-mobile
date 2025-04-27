import 'package:flutter/material.dart';
import 'package:packup/l10n/app_localizations.dart';

import 'package:packup/const/color.dart';
import 'package:packup/provider/search_bar/custom_search_bar_provider.dart';

import 'package:packup/widget/schedule/calendar.dart';
import 'package:provider/provider.dart';

import 'package:packup/widget/search_bar/custom_search_bar.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final paddingTop = MediaQuery.of(context).padding.top;

    final usableHeight = screenHeight - appBarHeight - paddingTop;

    return ChangeNotifierProvider(
      create: (_) => SearchBarProvider()..setApiUrl('schedule/search'),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: PRIMARY_COLOR,
          title: Text(
            AppLocalizations.of(context)!.login,
            style: TextStyle(color: TEXT_COLOR_W),
          ),
        ),
        body: Center(
          child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: CustomSearchBar(),
                ),
                Calendar(),
              ],
            ),
          ),
      ),
    );
  }

}




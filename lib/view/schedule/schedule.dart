import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:mob/const/color.dart';
import 'package:mob/common/util.dart';

import 'package:mob/widget/schedule/calendar.dart';
import 'package:mob/view/schedule/schedule_view_model.dart';
import 'package:provider/provider.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _userIdErrorText = '';
  String _userPasswordErrorText = '';

  @override
  Widget build(BuildContext context) {

    // final viewModel = context.watch<ScheduleViewModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: PRIMARY_COLOR,
        title: Text(
            AppLocalizations.of(context)!.login,
            style: TextStyle(color: TEXT_COLOR_W)
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: const [
            Calendar()
          ]
        ),
      )
    );
  }
}

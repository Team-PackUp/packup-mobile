import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/profile/setting_account/setting/section/setting_push_section.dart';

import '../../../../widget/common/alert_bell.dart';

class SettingPush extends StatefulWidget {
  const SettingPush({super.key});

  @override
  State<SettingPush> createState() => _SettingPushState();
}

class _SettingPushState extends State<SettingPush> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          title: '알림 수신 설정',
          alert: AlertBell(),
        ),
      body: SettingPushSection()
    );
  }
}
import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';

import '../../../../widget/common/alert_bell.dart';
import '../../../../widget/profile/setting_account/setting/section/setting_withdraw_section.dart';

class SettingWithdraw extends StatefulWidget {
  const SettingWithdraw({super.key});

  @override
  State<SettingWithdraw> createState() => _SettingWithdrawState();
}

class _SettingWithdrawState extends State<SettingWithdraw> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          title: '탈퇴하기',
          alert: AlertBell(),
        ),
      body: SettingWithdrawSection()
    );
  }
}
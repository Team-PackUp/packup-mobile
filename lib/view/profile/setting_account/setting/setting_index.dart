import 'package:flutter/material.dart';

import '../../../../widget/common/alert_bell.dart';
import '../../../../widget/common/custom_appbar.dart';
import '../../../../widget/profile/setting_account/setting/section/setting_index_section.dart';

class SettingIndex extends StatelessWidget {
  const SettingIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
        arrowFlag: false,
        title: '앱 설정',
        alert: AlertBell(),
    ),
    body: const SettingIndexSection()
    );
  }

}
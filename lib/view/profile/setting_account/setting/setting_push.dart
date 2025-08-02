import 'package:flutter/material.dart';

import '../../../../widget/profile/setting_account/setting/section/setting_index_section.dart';

class SettingPush extends StatefulWidget {
  const SettingPush({super.key});

  @override
  State<SettingPush> createState() => _SettingPushState();
}

class _SettingPushState extends State<SettingPush> {
  bool receiveAll = true;
  bool marketing = true;
  bool ad = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("알림 수신 설정"),
      ),
      body: SettingIndexSection()
    );
  }
}
import 'package:flutter/material.dart';

import '../../../../widget/profile/setting_account/setting/push_setting_card.dart';

class PushSetting extends StatefulWidget {
  const PushSetting({super.key});

  @override
  State<PushSetting> createState() => _PushSettingState();
}

class _PushSettingState extends State<PushSetting> {
  bool receiveAll = true;
  bool marketing = true;
  bool ad = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("알림 수신 설정"),
      ),
      body: ListView(
        children: [
          PushSettingCard(
            title: "일반 푸시 수신",
            subtitle: "서비스 이용 관련 알림 수신",
            value: receiveAll,
            onChanged: (val) => setState(() => receiveAll = val),
          ),
          const Divider(),
          PushSettingCard(
            title: "마케팅 푸시 수신 동의",
            subtitle: "이벤트, 할인 등 마케팅 정보 수신",
            value: marketing,
            onChanged: (val) => setState(() => marketing = val),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/view/profile/setting_account/setting/setting_push.dart';

import '../setting_push_card.dart';

class SettingIndexSection extends StatefulWidget {
  const SettingIndexSection({super.key});

  @override
  State<SettingIndexSection> createState() => _SettingIndexSectionState();

}

class _SettingIndexSectionState extends State<SettingIndexSection> {

  @override
  Widget build(BuildContext context) {
    bool receiveAll = true;
    bool marketing = true;
    bool ad = true;

    return ListView(
      children: [
        SettingPushCard(
          title: "일반 푸시 수신",
          subtitle: "서비스 이용 관련 알림 수신",
          value: receiveAll,
          onChanged: (val) => setState(() => receiveAll = val),
        ),
        const Divider(),
        SettingPushCard(
          title: "마케팅 푸시 수신 동의",
          subtitle: "이벤트, 할인 등 마케팅 정보 수신",
          value: marketing,
          onChanged: (val) => setState(() => marketing = val),
        ),
      ],
    );
  }
}

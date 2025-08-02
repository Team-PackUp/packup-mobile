import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../setting_push_card.dart';

class SettingPushSection extends StatefulWidget {
  const SettingPushSection({super.key});

  @override
  State<SettingPushSection> createState() => _SettingPushSectionState();

}

class _SettingPushSectionState extends State<SettingPushSection> {
  bool receiveAll = true;
  bool marketing = true;
  bool ad = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SettingPushCard(
          title: "일반 푸시 수신",
          subtitle: "서비스 이용 관련 알림 수신 동의",
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
        // SettingPushCard(
        //   title: "광고 푸시 수신 동의",
        //   subtitle: "신규 상품, 프로모션 등 광고 정보 수신",
        //   value: ad,
        //   onChanged: (val) => setState(() => ad = val),
        // ),
      ],
    );
  }
}

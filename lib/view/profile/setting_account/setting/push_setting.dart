import 'package:flutter/material.dart';

class PushSetting extends StatefulWidget {
  const PushSetting({super.key});

  @override
  State<PushSetting> createState() => _PushSettingState();
}

class _PushSettingState extends State<PushSetting> {
  bool receiveAll = true;
  bool marketing = true;
  bool chat = true;
  bool tour = true;
  bool ad = true;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("알림 수신 설정"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("전체 푸시 수신"),
            value: receiveAll,
            onChanged: (value) {
              setState(() {
                receiveAll = value;

                // 전체 OFF 시 개별도 OFF 처리
                if (!value) {
                  marketing = false;
                  chat = false;
                  tour = false;
                  ad = false;
                }
              });
            },
          ),
          const Divider(),

          SwitchListTile(
            title: const Text("마케팅 푸시 수신 동의"),
            subtitle: const Text("이벤트, 할인 등 광고성 정보 수신"),
            value: marketing,
            onChanged: receiveAll
                ? (value) => setState(() => marketing = value)
                : null,
          ),

          SwitchListTile(
            title: const Text("채팅 알림"),
            value: chat,
            onChanged: receiveAll
                ? (value) => setState(() => chat = value)
                : null,
          ),

          SwitchListTile(
            title: const Text("투어 관련 알림"),
            value: tour,
            onChanged: receiveAll
                ? (value) => setState(() => tour = value)
                : null,
          ),

          SwitchListTile(
            title: const Text("광고 및 프로모션 알림"),
            value: ad,
            onChanged: receiveAll
                ? (value) => setState(() => ad = value)
                : null,
          ),
        ],
      ),
    );
  }
}

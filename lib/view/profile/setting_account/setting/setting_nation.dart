import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/user/user_provider.dart';

import '../../../../widget/profile/setting_account/setting/section/setting_nation_section.dart';

class SettingNation extends StatelessWidget {
  const SettingNation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: '국가/지역 설정',
      ),
      body: SettingNationSection(
        onSaved: (code) {
          // 필요시 페이지 레벨 후처리
        },
      ),
    );
  }
}

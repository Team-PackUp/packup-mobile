import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/user/user_provider.dart';

import '../../../../widget/profile/setting_account/setting/section/setting_nation_section.dart';

class SettingNation extends StatelessWidget {
  const SettingNation({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().userModel;
    final initialCode = user?.userNation ?? '030001';

    return Scaffold(
      appBar: AppBar(
        title: const Text('국가/지역 설정', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SettingNationSection(
            initialCountryCode: initialCode,
            onSaved: (code) {
              // 필요시 페이지 레벨 후처리
            },
          ),
        ),
      ),
    );
  }
}

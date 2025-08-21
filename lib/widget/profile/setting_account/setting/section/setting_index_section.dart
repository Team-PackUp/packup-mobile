import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/util_widget.dart';
import '../setting_normal_list.dart';

class SettingIndexSection extends StatelessWidget {
  const SettingIndexSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenH * 0.015),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.04,
            vertical: screenH * 0.01,
          ),
          child: Text(
            '일반설정',
            style: TextStyle(
              fontSize: screenW * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        SettingNormalList(
          onTapNation: () => context.push('/profile/setting-nation'),
          onTapLanguage: () => context.push('/profile/setting-language'),
        ),

        SizedBox(height: screenH * 0.03),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.04,
            vertical: screenH * 0.01,
          ),
          child: Text(
            '기타',
            style: TextStyle(
              fontSize: screenW * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        CustomButton.textIconButton(
          context: context,
          icon: Icons.logout,
          label: '로그아웃',
          onPressed: () {
            context.read<UserProvider>().logout(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('로그아웃 되었습니다!')));
          },
        ),
        CustomButton.textIconButton(
          context: context,
          icon: Icons.delete_forever,
          label: '탈퇴하기',
          onPressed: () => context.push('/profile/withdraw'),
        ),
      ],
    );
  }
}

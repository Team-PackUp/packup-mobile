import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/util_widget.dart';

class SettingIndexSection extends StatelessWidget {
  const SettingIndexSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    final textStyle = TextStyle(fontSize: screenW * 0.04);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenH * 0.015),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.04, vertical: screenH * 0.01),
          child: Text(
            '알림설정',
            style: TextStyle(
              fontSize: screenW * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.notifications, size: screenW * 0.06, color: Colors.grey),
          title: Text('알림 수신 설정', style: textStyle),
          trailing: Icon(Icons.chevron_right, size: screenW * 0.05),
          onTap: () => context.push('/profile/push-setting'),
        ),

        SizedBox(height: screenH * 0.03),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.04, vertical: screenH * 0.01),
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
          onPressed: () => context.read<UserProvider>().logout(context),
        ),

        CustomButton.textIconButton(
          context: context,
          icon: Icons.delete_forever,
          label: '탈퇴하기',
          onPressed: () => context.push('/profile/withdraw'),
        )
      ],
    );
  }
}

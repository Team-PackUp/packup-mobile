import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:provider/provider.dart';

class SettingIndexSection extends StatelessWidget {
  const SettingIndexSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    final items = {
      '알림설정': [
        {'title': '알림 수신 설정', 'icon': Icons.notifications, 'url': '/profile/notification'},
      ],
      '기타': [
        {'title': '로그아웃', 'icon': Icons.logout, 'url': '/logout'},
        {'title': '탈퇴하기', 'icon': Icons.delete, 'url': '/withdraw'},
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenH * 0.015),
        for (final section in items.entries) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenW * 0.04, vertical: screenH * 0.01),
            child: Text(
              section.key,
              style: TextStyle(
                fontSize: screenW * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ...section.value.map((item) => ListTile(
            leading: Icon(item['icon'] as IconData, size: screenW * 0.06, color: Colors.grey),
            title: Text(item['title'] as String, style: TextStyle(fontSize: screenW * 0.04)),
            trailing: Icon(Icons.chevron_right, size: screenW * 0.05),
            onTap: () async {
              if (item['url'] == '/logout') {
                await context.read<UserProvider>().logout();
              } else {
                context.push(item['url'] as String);
              }
            },
          )),
        ],
      ],
    );
  }
}

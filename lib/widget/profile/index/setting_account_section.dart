import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingAccountSection extends StatelessWidget {
  final double w;
  final double h;

  const SettingAccountSection({super.key, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': '프로필 수정', 'icon': Icons.person, 'url': '/profile/profile_modify'},
      {'title': '예약 관리', 'icon': Icons.calendar_today, 'url': '/reservation/list'},
      {'title': '찜한 목록', 'icon': Icons.favorite_border, 'url': '/profile/update'},
      {'title': '결제 내역', 'icon': Icons.credit_card, 'url': '/profile/update'},
      {'title': '공지사항', 'icon': Icons.notifications, 'url': '/notice_list'},
      {'title': '앱 설정', 'icon': Icons.settings, 'url': '/profile/setting_index'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('설정 및 계정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.045)),
        SizedBox(height: h * 0.015),
        ...items.map((item) => ListTile(
          leading: Icon(item['icon'] as IconData, size: w * 0.06, color: Colors.grey),
          title: Text(item['title'] as String, style: TextStyle(fontSize: w * 0.04)),
          trailing: Icon(Icons.chevron_right, size: w * 0.05),
          onTap: () {
            context.push(item['url'].toString());
          },
        )),
      ],
    );
  }
}
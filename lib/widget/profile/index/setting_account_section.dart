import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/size_config.dart';

class SettingAccountSection extends StatelessWidget {
  const SettingAccountSection({super.key});

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

    double _s(double dp, {double min = 0.9, double max = 1.25}) {
      final sb = context.scaleBalanced;
      final s = sb.clamp(min, max);
      return dp * s;
    }

    final titleStyle     = TextStyle(fontWeight: FontWeight.bold, fontSize: _s(16));
    final itemTitleStyle = TextStyle(fontSize: _s(14));
    final leadingSize    = _s(22);
    final trailingSize    = _s(18);

    final itemSpacing = _s(1);
    final itemVPad    = _s(8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('설정 및 계정', style: titleStyle),
        SizedBox(height: _s(10)),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: itemSpacing),
          itemBuilder: (context, i) {
            final item = items[i];
            return ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.symmetric(vertical: itemVPad),
              leading: Icon(item['icon'] as IconData, size: leadingSize, color: Colors.grey),
              title: Text(item['title'] as String, style: itemTitleStyle),
              trailing: Icon(Icons.chevron_right, size: trailingSize),
              onTap: () => context.push(item['url'] as String),
            );
          },
        ),
      ],
    );
  }
}

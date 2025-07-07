import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/profile/profile_card.dart';

class ProfileMenuItem {
  final String title;
  final String? route;

  const ProfileMenuItem({
    required this.title,
    this.route,
  });
}

final List<ProfileMenuItem> menuItems = [
  ProfileMenuItem(
      title: '공지사항',
      route: '/notice_list'
  ),
  ProfileMenuItem(
      title: '고객센터',
      route: '/contact_center'
  ),
  ProfileMenuItem(
    title: '알림센터',
    route: '/alert_center'
  ),
];

class ProfileIndex extends StatefulWidget {
  const ProfileIndex({super.key});

  @override
  State<ProfileIndex> createState() => _ProfileIndexState();
}

class _ProfileIndexState extends State<ProfileIndex> {

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppbar(
        arrowFlag: false,
        title: 'Profile',
      ),
      body: Column(
        children: [
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: w * .02, vertical: h * .01),
              itemCount: menuItems.length,
              separatorBuilder: (_, __) => SizedBox(height: h * .01),
              itemBuilder: (_, idx) {
                final item = menuItems[idx];
                return ProfileCard(
                  title: item.title,
                  onTap: () {
                    context.push(item.route!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
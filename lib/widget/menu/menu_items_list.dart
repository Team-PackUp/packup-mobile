import 'package:flutter/material.dart';

class MenuItemsList extends StatelessWidget {
  const MenuItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: const [
          _MenuItem(
            icon: Icons.settings_suggest_outlined,
            label: '가이드 계정 관리',
            dividerAfter: true,
          ),
          _MenuItem(
            icon: Icons.balance_outlined,
            label: '법률',
            dividerAfter: true,
          ),
          _MenuItem(icon: Icons.logout_outlined, label: '로그아웃'),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool dividerAfter;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.dividerAfter = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap ?? () {}, // TODO: 라우팅 연결
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 28,
    );

    if (!dividerAfter) return tile;
    return Column(children: [tile, const Divider(height: 1, thickness: .8)]);
  }
}

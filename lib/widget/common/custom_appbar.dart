import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.arrowFlag,
    this.alert,
    this.profile,
  });

  final String title;
  final bool? arrowFlag; // null 또는 true → 뒤로가기 표시
  final Widget? alert; // 알림 아이콘
  final Widget? profile; // 프로필 아바타

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,

      leading:
          (arrowFlag == null || arrowFlag == true)
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: context.pop,
              )
              : null,

      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,

      actions: [
        if (alert != null)
          Padding(padding: const EdgeInsets.only(right: 4.0), child: alert!),
        if (profile != null)
          Padding(padding: const EdgeInsets.only(right: 12.0), child: profile!),
      ],
    );
  }
}

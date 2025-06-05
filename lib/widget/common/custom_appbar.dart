import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/Const/color.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;

  const CustomAppbar({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Stack(
        alignment: Alignment.center,
        children: [
          // ⬅ Left: 뒤로가기 버튼
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.pop();
              },
            ),
          ),

          // ⬆ Center: 타이틀
          Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),

          // ➡ Right: trailing 위젯 (옵셔널)
          if (trailing != null)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: trailing!,
              ),
            ),
        ],
      ),
    );
  }
}

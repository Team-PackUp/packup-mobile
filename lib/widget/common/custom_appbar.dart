import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/Const/color.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? arrowFlag;
  final Widget? trailing;

  const CustomAppbar({
    super.key,
    required this.title,
    this.arrowFlag,
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
          if(arrowFlag == null || arrowFlag == true)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop();
                },
              ),
            ),

          // ⬆ Center: 타이틀 > theme 공통 처리
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          // ➡ Right: trailing 위젯 (옵셔널)
          if (trailing != null)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0, bottom: 4),
                child: trailing!,
              ),
            ),
        ],
      ),
    );
  }
}

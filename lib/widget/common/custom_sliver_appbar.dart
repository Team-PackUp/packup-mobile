import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.arrowFlag,
    this.alert,
    this.profile,
    this.bottom,
    this.floating = true, // 스크롤에 따라 띄울지 말지 결정
    this.snap = true,     // 살짝 스냅만 해도 동작할지 말지
    this.pinned = false,  // 툴바(앱바의 구성요소)가 상단에 부딪혖을때 고정할지 말지
    this.systemOverlayStyle,
  });

  final String title;
  final bool? arrowFlag;
  final Widget? alert;
  final Widget? profile;
  final PreferredSizeWidget? bottom;
  final bool floating;
  final bool snap;
  final bool pinned;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
      floating: floating,
      snap: snap,
      pinned: pinned,
      systemOverlayStyle: systemOverlayStyle,
      leading: (arrowFlag == null || arrowFlag == true)
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: context.pop,
      )
          : null,
      title: Text(title, style: const TextStyle(color: Colors.black)),
      centerTitle: true,
      actions: [
        if (alert != null)
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: alert!,
          ),
        if (profile != null)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: profile!,
          ),
      ],
      bottom: bottom,
    );
  }
}

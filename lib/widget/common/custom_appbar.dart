import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.arrowFlag,
    this.alert,
    this.profile,
    this.bottom,
    this.backgroundColor = Colors.white,
  });

  final String title;
  final bool? arrowFlag;
  final Widget? alert;
  final Widget? profile;
  final PreferredSizeWidget? bottom;
  final Color backgroundColor;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: (arrowFlag == null || arrowFlag == true)
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: context.pop,
      )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        if (alert != null)
          Padding(
            padding: EdgeInsets.only(right: screenW * 0.05),
            child: alert!,
          ),
        if (profile != null)
          Padding(
            padding: EdgeInsets.only(right: screenW * 0.05),
            child: GestureDetector(
              onTap: () {
                context.push('/profile/profile_modify');
              },
              child: profile!,
            ),
          ),
      ],
      bottom: bottom,
    );
  }
}

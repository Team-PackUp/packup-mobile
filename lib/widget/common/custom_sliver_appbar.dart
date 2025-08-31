import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../common/size_config.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.arrowFlag,
    this.alert,
    this.profile,
    this.bottom,
    this.floating = true,
    this.snap = true,
    this.pinned = false,
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
    double _s(double dp, {double min = 0.1, double max = 1.15}) {
      final s = context.scaleBalanced.clamp(min, max);
      return dp * s;
    }

    final titleSize    = _s(18);
    final actionBox    = _s(30);
    final iconSize     = _s(2);
    final actionGap    = _s(12);
    final rightPad     = context.safe.right + _s(12);
    final toolbarH     = _s(56, min: 0.95, max: 1.05);

    return SliverAppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      floating: floating,
      snap: snap,
      pinned: pinned,
      centerTitle: true,
      toolbarHeight: toolbarH,
      systemOverlayStyle: systemOverlayStyle,
      titleTextStyle: TextStyle(
        fontSize: titleSize,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      leading: (arrowFlag == null || arrowFlag == true)
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        iconSize: iconSize,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(width: actionBox, height: actionBox),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: context.pop,
      )
          : null,
      title: Text(title),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: rightPad),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (alert != null)
                SizedBox(
                  width: actionBox,
                  height: actionBox,
                  child: Center(
                    child:  alert!,
                )),
              if (alert != null && profile != null) SizedBox(width: actionGap),
              if (profile != null)
                SizedBox(
                  width: actionBox,
                  height: actionBox,
                  child: GestureDetector(
                    onTap: () => context.push('/profile/profile_modify'),
                    child: Center(child: profile!),
                  ),
                ),
            ],
          ),
        ),
      ],
      bottom: bottom,
    );
  }
}

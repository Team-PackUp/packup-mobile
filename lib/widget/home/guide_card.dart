import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/theme/typographies/app_typographies.dart';
import 'package:packup/widget/common/slide_text.dart';
import '../../common/size_config.dart';
import '../../model/guide/guide_model.dart';
import '../common/circle_profile_image.dart'; // sX/sY

class GuideCard extends StatelessWidget {
  const GuideCard({super.key, required this.guide, this.width});
  final GuideModel guide;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final h = constraints.hasBoundedHeight && constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : context.sh; // fallback

        final designH = context.sY(280);
        final shrink = (h / designH).clamp(0.75, 1.0);

        double sX(double v) => context.sX(v) * shrink;
        double sY(double v) => context.sY(v) * shrink;

        final hPad    = sX(12);
        final vPad    = sY(12);
        final vGapS   = sY(6);
        final vGapM   = sY(10);
        double avatarR = sX(52).clamp(24, 52); // 너무 크면 줄임
        final br      = sX(16);

        final chipHPad = sX(12);
        final chipVPad = sY(6);
        final chipBR   = sX(12);

        return SizedBox(
          width: width,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(br),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: sX(8),
              vertical: sY(6),
            ),
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleProfileImage(imagePath: guide.user?.profileImagePath ?? '', radius: avatarR * 0.8),
                  SizedBox(height: vGapM),
                  // 이름: 필요시 줄바꿈 허용
                  Flexible(
                      child: SlideText(title: guide.user?.nickname ?? '')
                  ),
                  SizedBox(height: vGapS),
                  Flexible(
                    child: SlideText(title: guide.expertise ?? '')
                  ),
                  SizedBox(height: vGapM),
                  // TextButton(
                  //   onPressed: () {},
                  //   style: TextButton.styleFrom(
                  //     padding: EdgeInsets.zero,
                  //     minimumSize: const Size(0, 0),
                  //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //   ),
                  //   child: Text(
                  //     '프로필 보기',
                  //     style: AppTypographies.get(
                  //       size: AppFontSize.sm,
                  //       weight: AppFontWeight.medium,
                  //       color: SELECTED,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

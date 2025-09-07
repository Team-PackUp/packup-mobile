import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/theme/typographies/app_typographies.dart';
import '../../common/size_config.dart'; // sX/sY

class GuideTempCard extends StatelessWidget {
  const GuideTempCard({super.key, required this.guide, this.width});
  final GuideModelTemp guide;
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
                  CircleAvatar(
                    radius: avatarR,
                    backgroundImage: NetworkImage(guide.image ?? ''),
                  ),
                  SizedBox(height: vGapM),
                  // 이름: 필요시 줄바꿈 허용
                  Text(
                    guide.name ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypographies.get(
                      size: AppFontSize.base,
                      weight: AppFontWeight.bold,
                    ),
                  ),
                  SizedBox(height: vGapS),
                  Flexible(
                    child: Text(
                      guide.desc ?? '',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypographies.get(
                        size: AppFontSize.xs,
                        weight: AppFontWeight.normal,
                        color: TEXT_COLOR_B2,
                      ),
                    ),
                  ),
                  SizedBox(height: vGapM),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: chipHPad,
                        vertical: chipVPad,
                      ),
                      decoration: BoxDecoration(
                        color: SELECTED,
                        borderRadius: BorderRadius.circular(chipBR),
                      ),
                      child: Text(
                        '${guide.tours ?? 0}개 투어 진행중',
                        style: AppTypographies.get(
                          size: AppFontSize.xs,
                          weight: AppFontWeight.medium,
                          color: TEXT_COLOR_W,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: vGapS),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '프로필 보기',
                      style: AppTypographies.get(
                        size: AppFontSize.sm,
                        weight: AppFontWeight.medium,
                        color: SELECTED,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

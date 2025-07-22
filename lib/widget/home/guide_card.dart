import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/theme/typographies/app_typographies.dart';

class GuideCard extends StatelessWidget {
  const GuideCard({super.key, required this.guide});
  final GuideModelTemp guide;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final cardWidth = screenW * 0.4;

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.symmetric(
          horizontal: screenW * 0.02,
          vertical: screenH * 0.01,
        ),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage(guide.image ?? ''),
                ),
                SizedBox(height: screenH * 0.01),
                Text(
                  guide.name ?? '',
                  style: AppTypographies.get(
                    size: AppFontSize.base,
                    weight: AppFontWeight.bold,
                  ),
                ),
                SizedBox(height: screenH * 0.01),
                Text(
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
                SizedBox(height: screenH * 0.01),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: SELECTED,
                    borderRadius: BorderRadius.circular(20),
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
                const Spacer(),
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
      ),
    );
  }
}

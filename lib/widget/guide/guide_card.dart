import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/theme/typographies/app_typographies.dart';

class GuideCard extends StatelessWidget {
  final String name;
  final String desc;
  final int tourCount;
  final String imageUrl;

  const GuideCard({
    super.key,
    required this.name,
    required this.desc,
    required this.tourCount,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: BACK_GROUND_COLOR_W,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 32, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(height: 12),

          // 이름
          Text(
            name,
            style: AppTypographies.get(
              size: AppFontSize.base,
              weight: AppFontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // 소개
          Text(
            desc,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypographies.get(
              size: AppFontSize.xs,
              weight: AppFontWeight.normal,
              color: TEXT_COLOR_B2,
            ),
          ),

          const SizedBox(height: 8),

          // 진행중 뱃지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: SELECTED,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$tourCount개 투어 진행중',
              style: AppTypographies.get(
                size: AppFontSize.xs,
                weight: AppFontWeight.medium,
                color: TEXT_COLOR_W,
              ),
            ),
          ),

          const Spacer(),

          TextButton(
            onPressed: () {
              // TODO: 프로필 이동 처리
            },
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
    );
  }
}

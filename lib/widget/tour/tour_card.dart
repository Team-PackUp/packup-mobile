import 'package:flutter/material.dart';
import 'package:packup/common/util.dart';
import 'package:packup/main.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/theme/colors/app_colors_dark.dart';
import 'package:packup/theme/colors/app_colors_light.dart';
import 'package:packup/theme/shape/app_shapes.dart';
import 'package:packup/theme/sizes/app_sizes.dart';
import 'package:packup/theme/typographies/app_typographies.dart';

class TourCard extends StatelessWidget {
  final TourModel tour;
  final bool? isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const TourCard({
    super.key,
    required this.tour,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        PackUp.themeNotifier.value == ThemeMode.light
            ? lightColors
            : darkColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: AppSizes.cardMaxWidth),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppShapes.xlRadius,
          boxShadow: AppShapes.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child:
                      (tour.titleImagePath?.isNotEmpty ?? false)
                          ? Image.network(
                            tour.titleImagePath!,
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  width: double.infinity,
                                  height: 160,
                                  color: colors.surfaceTint.withAlpha(
                                    (0.1 * 255).round(),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '이미지를 불러올 수 없습니다',
                                    style: AppTypographies.caption.copyWith(
                                      color: colors.onSurface,
                                    ),
                                  ),
                                ),
                          )
                          : Container(
                            width: double.infinity,
                            height: 160,
                            color: colors.surfaceTint.withAlpha(
                              (0.1 * 255).round(),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '이미지가 없습니다',
                              style: AppTypographies.caption.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                          ),
                ),
                if (true)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '마감 임박!',
                        style: AppTypographies.get(
                          size: AppFontSize.sm,
                          weight: AppFontWeight.medium,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                // 즐겨찾기 버튼
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: colors.surface,
                      child: Icon(
                        isFavorite == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            isFavorite == true ? colors.error : colors.outline,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── 텍스트 정보
            Padding(
              padding: const EdgeInsets.all(AppSizes.gapMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AppFontSize.lg.size * 1.3 * 2, // 폰트크기 × 줄간격 × 2줄
                    child: Text(
                      tour.tourTitle ?? '제목 없음',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: AppTypographies.get(
                        size: AppFontSize.lg,
                        weight: AppFontWeight.semiBold,
                        height: 1.3, // 줄간격
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppTypographies.textBaseTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        tour.tourLocation ?? '위치 정보 없음',
                        style: AppTypographies.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'KRW ${formatAmount(tour.tourPrice!)}',
                    style: AppTypographies.get(
                      size: AppFontSize.lg,
                      weight: AppFontWeight.semiBold,
                      color: colors.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (tour.guide?.guideAvatarPath?.isNotEmpty == true)
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(
                            tour.guide!.guideAvatarPath!,
                          ),
                          onBackgroundImageError: (_, __) {},
                        )
                      else
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: colors.error,
                          child: Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        tour.guide?.guideName?.isNotEmpty == true
                            ? tour.guide!.guideName!
                            : '가이드 이름 없음',
                        style: AppTypographies.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

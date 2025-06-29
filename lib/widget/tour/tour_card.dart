import 'package:flutter/material.dart';
import 'package:packup/main.dart';
import 'package:packup/theme/colors/app_colors_dark.dart';
import 'package:packup/theme/colors/app_colors_light.dart';
import 'package:packup/theme/shape/app_shapes.dart';
import 'package:packup/theme/sizes/app_sizes.dart';
import 'package:packup/theme/typographies/app_typographies.dart';

class TourCard extends StatelessWidget {
  final String? imageUrl;
  final String? badgeText;
  final String? title;
  final String? location;
  final String? price;
  final String? hostName;
  final String? hostImageUrl;
  final bool? isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const TourCard({
    super.key,
    this.imageUrl,
    this.badgeText,
    this.title,
    this.location,
    this.price,
    this.hostName,
    this.hostImageUrl,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = PackUp.themeNotifier.value == ThemeMode.light
        ? lightColors
        : darkColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: AppSizes.cardMaxWidth),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppShapes.xlRadius,
          boxShadow: AppShapes.shadowMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 이미지 + 배지 + 즐겨찾기 버튼
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: (imageUrl?.isNotEmpty ?? false)
                      ? Image.network(
                    imageUrl!,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 160,
                      color: colors.surfaceTint.withOpacity(0.1),
                      alignment: Alignment.center,
                      child: Text(
                        '이미지를 불러올 수 없습니다',
                        style: AppTypographies.caption.copyWith(color: colors.onSurface),
                      ),
                    ),
                  )
                      : Container(
                    width: double.infinity,
                    height: 160,
                    color: colors.surfaceTint.withOpacity(0.1),
                    alignment: Alignment.center,
                    child: Text(
                      '이미지가 없습니다',
                      style: AppTypographies.caption.copyWith(color: colors.onSurface),
                    ),
                  ),
                ),
                if ((badgeText?.isNotEmpty ?? false))
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badgeText!,
                        style: AppTypographies.get(
                          size: AppFontSize.sm,
                          weight: AppFontWeight.bold,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: Icon(
                        isFavorite == true ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite == true ? colors.error : colors.outline,
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
                  Text(
                    title ?? '제목 없음',
                    style: AppTypographies.get(
                      size: AppFontSize.lg,
                      weight: AppFontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppTypographies.textBaseTertiary),
                      const SizedBox(width: 4),
                      Text(location ?? '위치 정보 없음', style: AppTypographies.caption),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price ?? '가격 미정',
                    style: AppTypographies.get(
                      size: AppFontSize.lg,
                      weight: AppFontWeight.semiBold,
                      color: colors.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if ((hostImageUrl?.isNotEmpty ?? false))
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(hostImageUrl!),
                          onBackgroundImageError: (_, __) {},
                        )
                      else
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 16, color: Colors.white),
                        ),
                      const SizedBox(width: 8),
                      Text(hostName ?? '호스트 없음', style: AppTypographies.caption),
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

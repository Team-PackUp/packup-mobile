import 'package:flutter/material.dart';
import 'package:packup/common/util.dart';
import 'package:packup/model/tour/tour_listing_model.dart';
import 'package:packup/widget/common/custom_network_image_ratio.dart';

class TourListingCard extends StatelessWidget {
  const TourListingCard({super.key, required this.item, this.onTap});
  final TourListingModel item;
  final VoidCallback? onTap;

  Color _badgeColor() {
    switch (item.status) {
      case TourListingStatus.published:
        return const Color(0xFF22C55E);
      case TourListingStatus.paused:
        return const Color(0xFFF59E0B);
      case TourListingStatus.inProgress:
        return const Color(0xFFF472B6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = fullFileUrl(item.coverImagePath ?? '');
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CustomNetworkImageRatio(imageUrl: imageUrl),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _badgeColor(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${item.statusKo} (In Progress)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${item.titleKo}${item.titleEn != null ? ' (${item.titleEn})' : ''}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Text(
                    '${item.categoryKo}${item.categoryEn != null ? ' (${item.categoryEn})' : ''}',
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(' • ', style: TextStyle(color: Color(0xFF6B7280))),
                  Text(
                    item.startDate != null
                        ? '${item.formattedStartKo()} ~'
                        : '',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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

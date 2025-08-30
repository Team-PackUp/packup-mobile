import 'package:flutter/material.dart';
import 'package:packup/common/util.dart';
import 'package:packup/model/tour/tour_listing_model.dart';
import 'package:packup/widget/common/custom_network_image_ratio.dart';

class TourListingCard extends StatelessWidget {
  const TourListingCard({super.key, required this.item, this.onTap});

  final TourListingModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = fullFileUrl(item.coverImagePath ?? '');

    final rawCode = (item.statusCode ?? item.legacyStatus?.name) ?? '';
    final status = _statusMeta(rawCode);

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 + 상태 배지
            Stack(
              children: [
                CustomNetworkImageRatio(imageUrl: imageUrl),
                if (status != null)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: status.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        status.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // 제목
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${item.titleKo}${item.titleEn != null ? ' (${item.titleEn})' : ''}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  height: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 카테고리
            if (item.categoryKo.isNotEmpty ||
                (item.categoryEn?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${item.categoryKo}${item.categoryEn != null ? ' (${item.categoryEn})' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ),

            const SizedBox(height: 4),

            // 날짜
            if (item.startDate != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Text(
                  '${item.formattedStartKo()} ~',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 상태코드 매핑 (대소문자 무시)
  _StatusMeta? _statusMeta(String? raw) {
    final code = (raw ?? '').toUpperCase();
    switch (code) {
      case 'TEMP':
        return const _StatusMeta('임시저장', Color(0xFF9CA3AF));
      case 'RECRUITING':
        return const _StatusMeta('모집중', Color(0xFF22C55E));
      case 'RECRUITED':
        return const _StatusMeta('모집완료', Color(0xFFF59E0B));
      case 'READY':
        return const _StatusMeta('출발대기', Color(0xFF3B82F6));
      case 'ONGOING':
        return const _StatusMeta('투어중', Color(0xFFA855F7));
      case 'FINISHED':
        return const _StatusMeta('종료', Color(0xFF111827));

      case 'PUBLISHED':
        return const _StatusMeta('게시 중', Color(0xFF22C55E));
      case 'PAUSED':
        return const _StatusMeta('일시중지', Color(0xFFF59E0B));
      case 'INPROGRESS':
        return const _StatusMeta('진행 중', Color(0xFFA855F7));
      default:
        return null;
    }
  }
}

class _StatusMeta {
  final String label;
  final Color color;
  const _StatusMeta(this.label, this.color);
}

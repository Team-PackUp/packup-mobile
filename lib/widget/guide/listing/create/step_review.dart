import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:packup/common/util.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepReview extends StatelessWidget {
  const StepReview({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListingCreateProvider>();

    final title = (p.getField<String>('basic.title') ?? '').trim();
    final desc = (p.getField<String>('basic.description') ?? '').trim();

    final place = p.getField<String>('meet.placeName') ?? '';
    final address = p.getField<String>('meet.address') ?? '';

    final files =
        p.getField<List>('photos.localPaths') ??
        p.getField<List>('photos.files') ??
        const [];
    final cover = files.isNotEmpty ? files.first : null;

    final itinCount = p.getField<int>('itinerary.count') ?? 0;
    final basicPrice = p.getField<int>('pricing.basic') ?? 0;
    final premiumMin = p.getField<int>('pricing.premiumMin') ?? 0;

    final keywords =
        (p.getField<List>('keywords.selected') ?? const []).cast<String>();

    bool? a = p.getField<bool>('provision.visitAttractions');
    bool? b = p.getField<bool>('provision.explainHistory');
    bool? c = p.getField<bool>('provision.driveGuests');

    String yn(bool? v) => v == null ? '미응답' : (v ? '예' : '아니요');

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '리스팅을 제출하세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              '세부 정보를 한 번 더 확인한 뒤 제출해 주세요.',
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 16),
            _CoverCard(coverPath: cover, title: title, desc: desc),

            const SizedBox(height: 16),
            _SectionDivider(),

            _NavTile(
              icon: Icons.tag_outlined,
              title: '키워드',
              subtitle: keywords.isEmpty ? '선택되지 않음' : keywords.join(', '),
              onTap:
                  () =>
                      context.read<ListingCreateProvider>().jumpTo('keywords'),
            ),
            _SectionDivider(),

            _NavTile(
              icon: Icons.title,
              title: title.isEmpty ? '제목 미입력' : title,
              subtitle: desc.isEmpty ? '소개 미입력' : desc,
              onTap:
                  () => context.read<ListingCreateProvider>().jumpTo('title'),
            ),
            _SectionDivider(),

            _NavTile(
              icon: Icons.place_outlined,
              title: place.isEmpty ? '장소 미선택' : place,
              subtitle: address.isEmpty ? null : address,
              onTap:
                  () =>
                      context.read<ListingCreateProvider>().jumpTo('location'),
            ),
            _SectionDivider(),

            _NavTile(
              icon: Icons.photo_library_outlined,
              title: '사진',
              subtitle: '${files.length}장 선택됨',
              onTap:
                  () => context.read<ListingCreateProvider>().jumpTo('photos'),
            ),
            _SectionDivider(),

            _NavTile(
              icon: Icons.event_note_outlined,
              title: '일정표',
              subtitle: '섹션 수: $itinCount',
              onTap:
                  () =>
                      context.read<ListingCreateProvider>().jumpTo('itinerary'),
            ),
            _SectionDivider(),

            _NavTile(
              icon: Icons.payments_outlined,
              title: '요금',
              subtitle:
                  premiumMin > 0
                      ? '게스트 1인당: ${formatPrice(basicPrice)} / 프라이빗 최저: ${formatPrice(premiumMin)}'
                      : '게스트 1인당: ${formatPrice(basicPrice)}',
              onTap:
                  () => context.read<ListingCreateProvider>().jumpTo(
                    'price_basic',
                  ),
            ),
            _SectionDivider(),

            _NavTile(
              icon: Icons.rule_folder_outlined,
              title: '세부 정보',
              subtitle: '관광명소 방문: ${yn(a)} · 역사 설명: ${yn(b)} · 운송: ${yn(c)}',
              onTap:
                  () =>
                      context.read<ListingCreateProvider>().jumpTo('provision'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverCard extends StatelessWidget {
  final dynamic coverPath; // String or null
  final String title;
  final String desc;
  const _CoverCard({
    required this.coverPath,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = coverPath is String && (coverPath as String).isNotEmpty;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (hasImage)
            _SafeImage(path: coverPath as String)
          else
            Container(
              height: 160,
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: const Text(
                '대표 사진 없음',
                style: TextStyle(color: Colors.black45),
              ),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                Text(
                  title.isEmpty ? '제목 미입력' : title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc.isEmpty ? '소개 미입력' : desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 아이템 섹션 타일
class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  const _NavTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle:
          subtitle == null
              ? null
              : Text(subtitle!, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 20, thickness: 1, color: Color(0xFFECECEC));
}

class _SafeImage extends StatelessWidget {
  final String path;
  const _SafeImage({required this.path});

  @override
  Widget build(BuildContext context) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');

    ImageProvider provider;
    if (isNetwork) {
      provider = NetworkImage(path);
    } else if (!kIsWeb && (path.startsWith('/') || path.startsWith('file:'))) {
      provider = FileImage(File(path));
    } else {
      provider = AssetImage(path);
    }

    return Image(
      image: provider,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      frameBuilder: (ctx, child, frame, wasSync) {
        if (wasSync || frame != null) return child;
        return Container(
          height: 180,
          color: Colors.grey[200],
          alignment: Alignment.center,
          child: const CircularProgressIndicator(strokeWidth: 2),
        );
      },
      errorBuilder:
          (ctx, err, stack) => Container(
            height: 180,
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: const Text(
              '이미지를 불러올 수 없습니다.',
              style: TextStyle(color: Colors.black45),
            ),
          ),
    );
  }
}

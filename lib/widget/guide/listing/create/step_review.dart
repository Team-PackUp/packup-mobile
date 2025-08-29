import 'package:packup/common/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepReview extends StatelessWidget {
  const StepReview({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListingCreateProvider>();

    final title = p.getField<String>('basic.title') ?? '';
    final desc = p.getField<String>('basic.description') ?? '';
    final place = p.getField<String>('meet.placeName') ?? '';
    final address = p.getField<String>('meet.address') ?? '';
    final basicPrice = p.getField<int>('pricing.basic') ?? 0;
    final premium = p.getField<int>('pricing.premiumMin') ?? 0;

    // 대표 사진: files/localPaths 중 첫 장
    final files =
        p.getField<List>('photos.localPaths') ??
        p.getField<List>('photos.files') ??
        const [];
    final coverPath = files.isNotEmpty ? files.first : null;

    Widget _sectionTitle(String t, String? sub) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        if (sub != null) ...[
          const SizedBox(height: 6),
          Text(sub, style: const TextStyle(color: Colors.white70)),
        ],
      ],
    );

    Widget _tile({
      required IconData icon,
      required String title,
      String? subtitle,
      required String goStepId,
    }) {
      return InkWell(
        onTap: () => context.read<ListingCreateProvider>().jumpTo(goStepId),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                '리스팅을 제출하세요',
                '세부 정보를 검토해 이상이 없는지 확인한 후 리스팅을 제출하세요.',
              ),
              const SizedBox(height: 16),

              // 커버 이미지 + 타이틀 카드
              if (coverPath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image(
                    image:
                        coverPath is String &&
                                (coverPath.startsWith('/') ||
                                    coverPath.startsWith('file:'))
                            ? AssetImage(coverPath)
                                as ImageProvider // 필요 시 FileImage로 교체
                            : NetworkImage(coverPath) as ImageProvider,
                    fit: BoxFit.cover,
                    height: 160,
                    width: double.infinity,
                  ),
                ),
              if (coverPath != null) const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Column(
                  children: [
                    Text(
                      title.isEmpty ? '제목 미입력' : title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc.isEmpty ? '소개 미입력' : desc,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 섹션 타일들
              const Divider(color: Colors.white12),
              _tile(
                icon: Icons.person,
                title: '호스트 소개',
                subtitle: '자격사항',
                goStepId: 'title',
              ), // 필요 시 해당 step으로 변경
              const Divider(color: Colors.white12),

              _tile(
                icon: Icons.place,
                title: place.isEmpty ? '장소 미선택' : place,
                subtitle: address.isEmpty ? null : address,
                goStepId: 'location',
              ),
              const Divider(color: Colors.white12),

              _tile(
                icon: Icons.photo_library_outlined,
                title: '사진',
                subtitle: '${files.length}장 선택됨',
                goStepId: 'photos',
              ),
              const Divider(color: Colors.white12),

              _tile(
                icon: Icons.event_note_outlined,
                title: '일정표',
                subtitle: '섹션 수: ${p.getField<int>('itinerary.count') ?? 0}',
                goStepId: 'itinerary',
              ),
              const Divider(color: Colors.white12),

              _tile(
                icon: Icons.payments_outlined,
                title: '요금',
                subtitle:
                    premium > 0
                        ? '게스트 1인당: ${formatPrice(basicPrice)} / 프라이빗 최저: ${formatPrice(premium)}'
                        : '게스트 1인당: ${formatPrice(basicPrice)}',
                goStepId: 'price_basic',
              ),
              const Divider(color: Colors.white12),

              _tile(
                icon: Icons.check_circle_outline,
                title: '세부 정보',
                subtitle: _provisionSummary(p),
                goStepId: 'provision',
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _provisionSummary(ListingCreateProvider p) {
    bool? a = p.getField<bool>('provision.visitAttractions');
    bool? b = p.getField<bool>('provision.explainHistory');
    bool? c = p.getField<bool>('provision.driveGuests');
    String yn(bool? v) => v == null ? '미응답' : (v ? '예' : '아니요');
    return '관광명소 방문: ${yn(a)} · 역사 설명: ${yn(b)} · 운송: ${yn(c)}';
  }
}

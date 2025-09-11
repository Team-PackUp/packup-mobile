// widget/reservation/section/reservation_time_list_section.dart
import 'package:flutter/material.dart';
import 'package:packup/provider/tour/reservation/reservation_provider.dart';
import 'package:provider/provider.dart';
import 'package:packup/model/tour/tour_session_model.dart';
import 'package:packup/widget/reservation/time_card.dart';

class ReservationTimeListSection extends StatelessWidget {
  const ReservationTimeListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ReservationProvider>();

    if (p.loading) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (p.sessions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(child: Text('예약 가능한 세션이 없습니다.')),
      );
    }

    // 월별 그룹핑
    final groups = <String, List<TourSessionModel>>{};
    for (final s in p.sessions) {
      final key = '${s.startTime.year}년 ${s.startTime.month}월';
      groups.putIfAbsent(key, () => []).add(s);
    }

    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 600; // 태블릿/웹 기준
    final horizontalPadding = isWide ? 24.0 : 12.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Align(
        // 폰: 꽉 차게 / 태블릿 이상: 720px 박스에 가운데 정렬
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWide ? 720 : double.infinity),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in groups.entries) ...[
                const SizedBox(height: 16),
                // 섹션 타이틀 디자인 살짝 업
                Text(
                  entry.key,
                  style:
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ) ??
                      const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                // 카드 리스트
                for (final s in entry.value) ...[
                  SizedBox(
                    width: double.infinity, // ★ 카드 가로 꽉 채우기
                    child: TimeCard(
                      dateText: _formatDateLabel(s.startTime),
                      time: _formatTimeRange(s.startTime, s.endTime),
                      price: _priceLabel(context),
                      subtitle: _subtitle(s),
                      remainText: _remainText(s),
                      isSelected: p.selected?.seq == s.seq,
                      onTap: () => p.selectSession(s),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateLabel(DateTime d) {
    const weekday = ['월', '화', '수', '목', '금', '토', '일'];
    return '${d.month}월 ${d.day}(${weekday[d.weekday - 1]}요일)';
  }

  String _formatTimeRange(DateTime s, DateTime e) {
    String fmt(DateTime t) {
      final h = t.hour;
      final m = t.minute.toString().padLeft(2, '0');
      final ampm = h < 12 ? '오전' : '오후';
      final hh = h % 12 == 0 ? 12 : h % 12;
      return '$ampm $hh:$m';
    }

    return '${fmt(s)} ~ ${fmt(e)}';
  }

  String _priceLabel(BuildContext context) {
    final price = context.read<ReservationProvider>().pricePerPerson;
    if (price <= 0) return '가격 문의';
    final s = price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => ',',
    );
    return '₩$s 1인당';
  }

  String _subtitle(TourSessionModel s) {
    final cap = s.capacity;
    final booked = s.bookedCount ?? 0;
    final remain = (cap ?? 99) - booked;
    if (remain <= 2) return '지금 예약이 몰리고 있어요';
    return '프라이빗 예약 요금 이용 가능';
  }

  String _remainText(TourSessionModel s) {
    final cap = s.capacity;
    final booked = s.bookedCount ?? 0;
    final remain = (cap ?? 99) - booked;
    final left = remain < 0 ? 0 : remain;
    return '${left}자리 남음';
  }
}

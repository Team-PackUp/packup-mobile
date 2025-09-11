import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/tour/reservation/reservation_provider.dart';
import 'package:packup/view/reservation/detail/reservation_confirm.dart';
import 'package:provider/provider.dart';

class ReservationSummarySection extends StatelessWidget {
  const ReservationSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ReservationProvider>();
    final selected = p.selected;
    final enabled = selected != null && p.remaining > 0;

    String titleText() {
      if (selected == null) return '세션 선택 필요';
      final d = selected.startTime;
      final date = '${d.month}월 ${d.day}일';
      final hh = _hhmm(d);
      return '게스트 ${p.guestCount}명 • $date $hh';
    }

    String priceText() {
      if (selected == null) return '-';
      final s = p.totalPrice.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => ',',
      );
      return '$s원';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(titleText(), style: const TextStyle(fontSize: 14)),
              Text(
                priceText(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: enabled ? () => _goNext(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                disabledBackgroundColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '다음',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _hhmm(DateTime t) {
    final ampm = t.hour < 12 ? '오전' : '오후';
    final hh = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final mm = t.minute.toString().padLeft(2, '0');
    return '$ampm $hh:$mm';
  }

  void _goNext(BuildContext context) {
    final p = context.read<ReservationProvider>();
    context.push('/reservation/confirm', extra: p);
  }
}

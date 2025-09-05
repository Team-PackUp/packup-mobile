import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/edit/tour_session_open_provider.dart';

class OpenSessionCreatePage extends StatelessWidget {
  final int tourSeq;
  final String? tourTitle;
  const OpenSessionCreatePage({
    super.key,
    required this.tourSeq,
    this.tourTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourSessionOpenProvider()..init(tourSeq),
      child: const _OpenSessionCreateView(),
    );
  }
}

class _OpenSessionCreateView extends StatelessWidget {
  const _OpenSessionCreateView();

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TourSessionOpenProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('예약 시간 열기')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 경고문구
              // 경고문구 (중앙정렬)
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '1명이상 투어 신청 후 예약 취소는 패널티 부여\n정산 시 금액차감 및 가이드 활동 제재',
                  textAlign: TextAlign.center, // ⬅️ 중앙 정렬
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.pink.shade600,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 달력
              _CalendarCard(),
              const SizedBox(height: 16),

              // 시간 슬롯 + duration
              _TimeGrid(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed:
                  prov.canSubmit && !prov.loading
                      ? () async {
                        await prov.submit();
                        if (context.mounted) {
                          final ok = prov.error == null;
                          if (ok) {
                            Navigator.pop(
                              context,
                              true,
                            ); // ← 목록 화면으로 success 반환
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('등록 실패: ${prov.error}')),
                            );
                          }
                        }
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  prov.loading
                      ? const CircularProgressIndicator.adaptive()
                      : const Text(
                        '등록',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ------- Calendar & Time widgets (간단 버전) ------- */
class _CalendarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TourSessionOpenProvider>();
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${prov.selectedDate.year}년 ${prov.selectedDate.month.toString().padLeft(2, '0')}월',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            CalendarDatePicker(
              initialDate: prov.selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateChanged:
                  (d) => context.read<TourSessionOpenProvider>().setDate(d),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeGrid extends StatelessWidget {
  static final List<TimeOfDay> _slots = [
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 30),
    const TimeOfDay(hour: 13, minute: 0),
    const TimeOfDay(hour: 14, minute: 30),
    const TimeOfDay(hour: 16, minute: 0),
    const TimeOfDay(hour: 17, minute: 30),
    const TimeOfDay(hour: 19, minute: 0),
    const TimeOfDay(hour: 20, minute: 30),
  ];
  static final List<Duration> _durations = [
    const Duration(minutes: 60),
    const Duration(minutes: 90),
    const Duration(minutes: 120),
  ];

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TourSessionOpenProvider>();
    final theme = Theme.of(context);
    final selected = prov.selectedStart;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '시간대 선택',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  _slots.map((t) {
                    final dt = DateTime(
                      prov.selectedDate.year,
                      prov.selectedDate.month,
                      prov.selectedDate.day,
                      t.hour,
                      t.minute,
                    );
                    final isSelected =
                        selected != null &&
                        selected.hour == t.hour &&
                        selected.minute == t.minute;
                    return ChoiceChip(
                      label: Text(_fmt(t)),
                      selected: isSelected,
                      onSelected:
                          (_) => context
                              .read<TourSessionOpenProvider>()
                              .pickTime(t.hour, t.minute),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '소요 시간',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<Duration>(
                  value: prov.duration,
                  items:
                      _durations.map((d) {
                        final label =
                            d.inMinutes == 60
                                ? '60분'
                                : d.inMinutes == 90
                                ? '90분'
                                : '120분';
                        return DropdownMenuItem(value: d, child: Text(label));
                      }).toList(),
                  onChanged:
                      (d) =>
                          d != null
                              ? context
                                  .read<TourSessionOpenProvider>()
                                  .setDuration(d)
                              : null,
                ),
                const Spacer(),
                if (prov.selectedStart != null)
                  Text(
                    '${_fmtTime(prov.selectedStart!)} ~ ${_fmtTime(prov.selectedEnd!)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  static String _fmtTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

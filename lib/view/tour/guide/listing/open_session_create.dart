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
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.pink.shade600,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 달력
              const _CalendarCard(),
              const SizedBox(height: 16),

              // 시간 슬롯 + duration
              const _TimeGrid(),
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
                            Navigator.pop(context, true); // 목록으로 success 반환
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

/* -------------------- Calendar -------------------- */
class _CalendarCard extends StatelessWidget {
  const _CalendarCard();

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

/* -------------------- Time Grid + Duration -------------------- */
class _TimeGrid extends StatelessWidget {
  const _TimeGrid();

  // 표시할 슬롯(필요 시 프로젝트 설정으로 빼도 좋음)
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

            // 2열 그리드 + 커스텀 칩
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _slots.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3.2,
              ),
              itemBuilder: (context, i) {
                final t = _slots[i];
                final isSelected =
                    selected != null &&
                    selected.hour == t.hour &&
                    selected.minute == t.minute;
                final disabled = _isPastSlot(prov.selectedDate, t);

                return TimeSlotChip(
                  label: _fmt(t),
                  selected: isSelected,
                  disabled: disabled,
                  onTap:
                      () => context.read<TourSessionOpenProvider>().pickTime(
                        t.hour,
                        t.minute,
                      ),
                );
              },
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

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// 오늘 선택 시, 현재 시각 이전 슬롯 비활성화
  static bool _isPastSlot(DateTime selectedDate, TimeOfDay slot) {
    final now = DateTime.now();
    if (!_isSameDay(selectedDate, now)) return false;
    final slotDt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      slot.hour,
      slot.minute,
    );
    return slotDt.isBefore(now);
  }

  static String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static String _fmtTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

/* -------------------- Custom Time Chip -------------------- */
class TimeSlotChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  const TimeSlotChip({
    super.key,
    required this.label,
    required this.selected,
    this.disabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final baseText = theme.textTheme.bodyMedium;

    final bg =
        selected
            ? primary.withOpacity(.12)
            : theme.colorScheme.surfaceVariant.withOpacity(.6);
    final border = selected ? primary : Colors.black.withOpacity(.08);
    final fg = selected ? primary : Colors.black.withOpacity(.75);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: disabled ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: disabled ? bg.withOpacity(.5) : bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: disabled ? border.withOpacity(.3) : border,
              width: selected ? 1.2 : 0.8,
            ),
            boxShadow:
                selected
                    ? [
                      BoxShadow(
                        color: primary.withOpacity(.12),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                    : const [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.access_time_rounded,
                size: 16,
                color: disabled ? fg.withOpacity(.4) : fg,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: baseText?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: disabled ? fg.withOpacity(.4) : fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

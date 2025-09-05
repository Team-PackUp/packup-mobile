import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/edit/tour_session_open_provider.dart';
import 'package:packup/model/tour/tour_session_model.dart';
import 'package:packup/const/tour/tour_session_status_code.dart';
import 'package:go_router/go_router.dart';
// 빈 화면 위젯 (질문에서 주신 것)
import 'package:packup/widget/tour/guide/listing/section/tour_listing_empty_section.dart';

class OpenSessionPage extends StatelessWidget {
  final int tourSeq;
  final String? tourTitle;
  const OpenSessionPage({super.key, required this.tourSeq, this.tourTitle});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourSessionOpenProvider()..init(tourSeq),
      child: _OpenSessionListView(tourSeq: tourSeq, tourTitle: tourTitle),
    );
  }
}

class _OpenSessionListView extends StatelessWidget {
  final int tourSeq;
  final String? tourTitle;
  const _OpenSessionListView({required this.tourSeq, this.tourTitle});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TourSessionOpenProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('투어 시간 열기')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '현재 열려있는 투어 시간',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),

              if (prov.loading && prov.sessions.isEmpty)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (prov.sessions.isEmpty)
                const Expanded(child: TourListingEmptySection())
              else
                Expanded(child: _OpenedSessionsList(sessions: prov.sessions)),
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
              onPressed: () async {
                final ok = await context.pushNamed<bool>(
                  'gListingOpenNew',
                  pathParameters: {'tourSeq': tourSeq.toString()},
                  extra: tourTitle,
                );
                if (ok == true && context.mounted) {
                  await context.read<TourSessionOpenProvider>().refresh();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('세션이 등록되었습니다.')));
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '날짜 추가',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* --- 날짜별 그룹 목록 --- */
class _OpenedSessionsList extends StatelessWidget {
  final List<TourSessionModel> sessions;
  const _OpenedSessionsList({required this.sessions});

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, List<TourSessionModel>> grouped = {};
    for (final s in sessions) {
      final k = DateTime(s.startTime.year, s.startTime.month, s.startTime.day);
      grouped.putIfAbsent(k, () => []).add(s);
    }
    final keys = grouped.keys.toList()..sort();

    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (_, i) {
        final day = keys[i];
        final items =
            grouped[day]!..sort((a, b) => a.startTime.compareTo(b.startTime));
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${day.month}/${day.day}',
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              ...items.map((s) => _SessionTile(s: s)),
            ],
          ),
        );
      },
    );
  }
}

class _SessionTile extends StatelessWidget {
  final TourSessionModel s;
  const _SessionTile({required this.s});

  @override
  Widget build(BuildContext context) {
    final label = s.status.label;
    final color = switch (s.status) {
      TourSessionStatusCode.open => Colors.green,
      TourSessionStatusCode.full => Colors.orange,
      TourSessionStatusCode.completed => Colors.blueGrey,
      TourSessionStatusCode.canceled => Colors.red,
    };
    final cap =
        (s.capacity != null && s.bookedCount != null)
            ? '신청자: ${s.bookedCount}/${s.capacity}명'
            : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(radius: 6, backgroundColor: color),
        title: Text(
          '${_t(s.startTime)} - ${_t(s.endTime)}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(cap ?? label),
        trailing: const Icon(Icons.expand_more),
        onTap: () {
          // TODO: 상세/수정 바텀시트 오픈(필요 시)
        },
      ),
    );
  }

  String _t(DateTime d) {
    final l = d.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(l.month)}/${two(l.day)} ${two(l.hour)}:${two(l.minute)}';
  }
}

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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _md(day),
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              ...items.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: _SessionTile(s: s),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _md(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.month)}/${two(d.day)}';
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
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minLeadingWidth: 0,
        leading: CircleAvatar(radius: 6, backgroundColor: color),
        title: Text(
          '${_dt(s.startTime)} - \n${_dt(s.endTime)}',
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.w700, height: 1.2),
        ),
        subtitle: Text(cap ?? label),
        trailing: const Icon(Icons.expand_more, size: 20),
        onTap: () {
          // TODO..
        },
      ),
    );
  }

  String _dt(DateTime d) {
    final l = d.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(l.month)}/${two(l.day)} ${two(l.hour)}:${two(l.minute)}';
  }
}

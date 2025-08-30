// lib/widget/guide/listing/create/step_keywords.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';
import 'package:packup/widget/profile/profile_modify/profile_preference_toogle_title.dart';

class StepKeywords extends StatefulWidget {
  const StepKeywords({super.key});
  @override
  State<StepKeywords> createState() => _StepKeywordsState();
}

class _StepKeywordsState extends State<StepKeywords> {
  final List<_PrefItem> _items = const [
    _PrefItem('🔍', '요리'),
    _PrefItem('📚', '독서'),
    _PrefItem('🏋️', '운동'),
    _PrefItem('🏖️', '여행 가이드'),
    _PrefItem('📝', '블로그'),
    _PrefItem('🖼️', '시각 콘텐츠'),
    _PrefItem('🎧', '오디오 콘텐츠'),
  ];

  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    final p = context.read<ListingCreateProvider>();
    final init = (p.getField<List>('keywords.selected') ?? const []) as List;
    _selected = {...init.map((e) => e.toString())};
  }

  void _commit() {
    context.read<ListingCreateProvider>().setField(
      'keywords.selected',
      _selected.toList(),
    );
  }

  void _toggle(String label, bool v) {
    setState(() {
      if (v) {
        _selected.add(label);
      } else {
        _selected.remove(label);
      }
    });
    _commit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Banner(
              text:
                  '투어 성격을 잘 드러내는 키워드를 선택해 주세요. '
                  '최소 1개 이상 선택을 권장합니다.',
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: '추천 키워드',
              children:
                  _items.map((p) {
                    final checked = _selected.contains(p.label);
                    return PreferenceToggleTile(
                      emoji: p.emoji,
                      label: p.label,
                      value: checked,
                      onChanged: (v) => _toggle(p.label, v),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrefItem {
  final String emoji;
  final String label;
  const _PrefItem(this.emoji, this.label);
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }
}

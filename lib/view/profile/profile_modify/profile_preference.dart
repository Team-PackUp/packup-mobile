import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import '../../../widget/profile/profile_modify/profile_preference_toogle_title.dart';

class ProfilePreference extends StatefulWidget {
  const ProfilePreference({super.key, required this.initialSelected, this.onChanged});

  final List<String> initialSelected;
  final ValueChanged<List<String>>? onChanged;

  @override
  State<ProfilePreference> createState() => _ProfilePreferenceState();
}

class _ProfilePreferenceState extends State<ProfilePreference> {
  final List<PrefItem> prefItems = const <PrefItem>[
    PrefItem('🔍', '요리'),
    PrefItem('📚', '독서'),
    PrefItem('🏋️', '운동'),
    PrefItem('🏖️', '여행 가이드'),
    PrefItem('📝', '블로그'),
    PrefItem('🖼️', '시각 콘텐츠'),
    PrefItem('🎧', '오디오 콘텐츠'),
  ];

  final Set<String> _selected = <String>{};
  Set<String> get _allLabels => prefItems.map((e) => e.label).toSet();

  @override
  void initState() {
    super.initState();

    _selected
      ..clear()
      ..addAll(widget.initialSelected.where(_allLabels.contains));

    // 첫 빌드 후 콜백
    WidgetsBinding.instance.addPostFrameCallback((_) => _emitSelection());
  }

  void _emitSelection() => widget.onChanged?.call(_selected.toList());

  void _toggle(String label, bool v) {
    setState(() {
      if (v) {
        _selected.add(label);
      } else {
        _selected.remove(label);
      }
    });
    _emitSelection();
  }

  final TextEditingController _preferenceController = TextEditingController();

  @override
  void dispose() {
    _preferenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "선호 카테고리"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _PreferenceBanner(
                text: '관심 있는 취미를 선택하고, 나만의 취미를 추가하여 맞춤형 경험을 만들어보세요.',
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: '인기 취미',
                children: prefItems.map((p) {
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
      ),
    );
  }
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
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _PreferenceBanner extends StatelessWidget {
  const _PreferenceBanner({required this.text});
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
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black54)),
    );
  }
}

class PrefItem {
  final String emoji;
  final String label;
  const PrefItem(this.emoji, this.label);
}

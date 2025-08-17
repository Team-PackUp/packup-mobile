import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';

class ProfilePreference extends StatefulWidget {
  const ProfilePreference({super.key, required this.initialSelected, this.onChanged});

  final List<String> initialSelected;
  final ValueChanged<List<String>>? onChanged;

  @override
  State<ProfilePreference> createState() => _ProfilePreferenceState();
}

class _ProfilePreferenceState extends State<ProfilePreference> {
  final Map<String, bool> popular = {
    '요리': false,
    '독서': false,
    '운동': false,
  };

  final Map<String, bool> arts = {
    '그림 그리기': false,
    '글쓰기': false,
    '사진 촬영': false,
    '음악 감상': false,
  };

  final Map<String, bool> sports = {
    '등산': false,
    '수영': false,
    '자전거 타기': false,
    '캠핑': false,
  };

  @override
  void initState() {
    super.initState();
    void setPreference(Map<String, bool> m) {
      for (final k in m.keys) {
        if (widget.initialSelected.contains(k)) m[k] = true;
      }
    }
    setPreference(popular);
    setPreference(arts);
    setPreference(sports);

    WidgetsBinding.instance.addPostFrameCallback((_) => _emitSelection());
  }

  void _emitSelection() {
    widget.onChanged?.call(_collectSelected());
  }

  List<String> _collectSelected() {
    final selected = <String>[];
    void addFrom(Map<String, bool> m) {
      m.forEach((k, v) { if (v) selected.add(k); });
    }
    addFrom(popular);
    addFrom(arts);
    addFrom(sports);
    return selected;
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
      appBar: CustomAppbar(
        title: "선호 카테고리",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PreferenceBanner(text: '관심 있는 취미를 선택하고, 나만의 취미를 추가하여 맞춤형 경험을 만들어보세요.'),
              const SizedBox(height: 12),
              _SectionCard(
                title: '인기 취미',
                children: [
                  PreferenceToggleTile(
                    emoji: '🔍',
                    label: '요리',
                    value: popular['요리']!,
                    onChanged: (v) => setState(() { popular['요리'] = v; _emitSelection(); }), // ✅ 즉시 통지
                  ),
                  PreferenceToggleTile(
                    emoji: '📚',
                    label: '독서',
                    value: popular['독서']!,
                    onChanged: (v) => setState(() { popular['독서'] = v; _emitSelection(); }),
                  ),
                  PreferenceToggleTile(
                    emoji: '🏋️',
                    label: '운동',
                    value: popular['운동']!,
                    onChanged: (v) => setState(() { popular['운동'] = v; _emitSelection(); }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: '예술/창작',
                children: [
                  PreferenceToggleTile(
                    emoji: '🎨',
                    label: '그림 그리기',
                    value: arts['그림 그리기']!,
                    onChanged: (v) => setState(() { arts['그림 그리기'] = v; _emitSelection(); }),
                  ),
                  PreferenceToggleTile(
                    emoji: '✍️',
                    label: '글쓰기',
                    value: arts['글쓰기']!,
                    onChanged: (v) => setState(() { arts['글쓰기'] = v; _emitSelection(); }),
                  ),
                  PreferenceToggleTile(
                    emoji: '📸',
                    label: '사진 촬영',
                    value: arts['사진 촬영']!,
                    onChanged: (v) => setState(() { arts['사진 촬영'] = v; _emitSelection(); }),
                  ),
                  PreferenceToggleTile(
                    emoji: '🎧',
                    label: '음악 감상',
                    value: arts['음악 감상']!,
                    onChanged: (v) => setState(() { arts['음악 감상'] = v; _emitSelection(); }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: '스포츠/야외 활동',
                children: [
                  PreferenceToggleTile(
                    emoji: '🥾',
                    label: '등산',
                    value: sports['등산']!,
                    onChanged: (v) => setState(() { sports['등산'] = v; _emitSelection(); }),
                  ),
                  PreferenceToggleTile(
                    emoji: '🏊',
                    label: '수영',
                    value: sports['수영']!,
                    onChanged: (v) => setState(() { sports['수영'] = v; _emitSelection(); }),
                  ),
                  PreferenceToggleTile(
                    emoji: '🚴',
                    label: '자전거 타기',
                    value: sports['자전거 타기']!,
                    onChanged: (v) => setState(() { sports['자전거 타기'] = v; _emitSelection(); }),
                  ),
                  PreferenceToggleTile(
                    emoji: '🏕️',
                    label: '캠핑',
                    value: sports['캠핑']!,
                    onChanged: (v) => setState(() { sports['캠핑'] = v; _emitSelection(); }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _AddPreferenceCard(
                controller: _preferenceController,
                onAdd: () {
                  final text = _preferenceController.text.trim();
                  if (text.isEmpty) return;
                  setState(() {
                    popular[text] = true;
                    _preferenceController.clear();
                    _emitSelection();
                  });
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class PreferenceToggleTile extends StatelessWidget {
  const PreferenceToggleTile({
    super.key,
    required this.emoji,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String emoji;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.surfaceVariant.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
  });

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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _AddPreferenceCard extends StatelessWidget {
  const _AddPreferenceCard({
    required this.controller,
    required this.onAdd,
  });

  final TextEditingController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6FFFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2F5EA)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '나만의 취미 추가',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: '새로운 취미 입력',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onSubmitted: (_) => onAdd(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onAdd,
              child: const Text('추가하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
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
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }
}

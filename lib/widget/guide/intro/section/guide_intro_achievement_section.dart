import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/guide/guide_intro_provider.dart';

class GuideIntroAchievementSection extends StatefulWidget {
  const GuideIntroAchievementSection({super.key});

  @override
  State<GuideIntroAchievementSection> createState() =>
      _GuideIntroAchievementSectionState();
}

class _GuideIntroAchievementSectionState
    extends State<GuideIntroAchievementSection> {
  late final TextEditingController _controller;
  static const int _maxLen = 90;

  final List<String> _suggestions = const [
    '누적 게스트 500+명',
    '트립어드바이저 수상 경력',
    '월간 만족도 4.9/5.0',
    '서울시 공식 해설사 활동',
    '언론 인터뷰/출연 경력',
  ];

  @override
  void initState() {
    super.initState();
    final p = context.read<GuideIntroProvider>();
    _controller = TextEditingController(text: p.data.achievement);
    _controller.addListener(() {
      context.read<GuideIntroProvider>().setAchievement(_controller.text);
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    final p = context.read<GuideIntroProvider>();
    if (_controller.text != p.data.achievement) {
      _controller.text = p.data.achievement;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _placeholder => '트립어드바이저 수상 경력\n누적 게스트 500+명\n언론 인터뷰/출연 경력';

  void _appendSuggestion(String text) {
    final cur = _controller.text;
    final sep = (cur.isEmpty || cur.endsWith('\n')) ? '' : '\n';
    final next = '$cur$sep$text';
    if (next.characters.length <= _maxLen) {
      _controller.text = next;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('90자를 초과할 수 없습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final curLen = _controller.text.characters.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            '직업적 성취를 입력해 주세요 (선택)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Wrap(
          //     spacing: 8,
          //     runSpacing: 8,
          //     children:
          //         _suggestions.map((s) {
          //           return ActionChip(
          //             label: Text(s, style: const TextStyle(fontSize: 12)),
          //             onPressed: () => _appendSuggestion(s),
          //             shape: const StadiumBorder(
          //               side: BorderSide(color: Color(0xFFE5E7EB)),
          //             ),
          //             backgroundColor: const Color(0xFFF8FAFC),
          //           );
          //         }).toList(),
          //   ),
          // ),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 300),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: _maxLen,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: _placeholder,
                    hintMaxLines: 3,
                    hintStyle: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.black.withOpacity(.25),
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$curLen/$_maxLen자 입력 가능',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black.withOpacity(.45),
                  ),
                ),
                const SizedBox(width: 16),
                // TextButton.icon(
                //   onPressed: () {
                //     _controller.clear();
                //   },
                //   icon: const Icon(Icons.clear, size: 16),
                //   label: const Text('지우기'),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/guide/guide_intro_provider.dart';

class GuideIntroExpertiseSection extends StatefulWidget {
  const GuideIntroExpertiseSection({super.key});

  @override
  State<GuideIntroExpertiseSection> createState() =>
      _GuideIntroExpertiseSectionState();
}

class _GuideIntroExpertiseSectionState
    extends State<GuideIntroExpertiseSection> {
  late final TextEditingController _controller;
  static const int _maxLen = 90;

  final List<String> _suggestions = const [
    '한식조리자격증 보유',
    '국내여행안내사 자격증 보유',
    '국외여행안내사 자격증 보유',
    '서울 도보투어 5년 진행',
    '영어/일본어 가능',
  ];

  @override
  void initState() {
    super.initState();
    final p = context.read<GuideIntroProvider>();
    _controller = TextEditingController(text: p.data.expertise);
    _controller.addListener(() {
      context.read<GuideIntroProvider>().setExpertise(_controller.text);
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    final p = context.read<GuideIntroProvider>();
    if (_controller.text != p.data.expertise) {
      _controller.text = p.data.expertise;
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

  String get _placeholder => '한식조리자격증 보유\n국내여행안내사 자격증 보유\n국외여행안내사 자격증 보유';

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
      // 초과 시 토스트/스낵바는 필요시 추가
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
            '경력을 소개해 주세요',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // 추천 문구 칩
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

          // 큰 입력 박스
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

          // 하단 카운터
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$curLen/$_maxLen자 입력 가능',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.black.withOpacity(.45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

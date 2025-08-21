import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/guide/guide_intro_provider.dart';

class GuideIntroRoleSection extends StatefulWidget {
  const GuideIntroRoleSection({super.key});

  @override
  State<GuideIntroRoleSection> createState() => _GuideIntroRoleSectionState();
}

class _GuideIntroRoleSectionState extends State<GuideIntroRoleSection> {
  late final TextEditingController _controller;
  static const int _maxLen = 90;

  @override
  void initState() {
    super.initState();
    final p = context.read<GuideIntroProvider>();
    _controller = TextEditingController(text: p.data.roleSummary);
    _controller.addListener(() {
      context.read<GuideIntroProvider>().setRoleSummary(_controller.text);
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    final p = context.read<GuideIntroProvider>();
    if (_controller.text != p.data.roleSummary) {
      _controller.text = p.data.roleSummary;
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

  String get _placeholder => '수년간 서울 맛집 탐방\n10년차 서울 직장인';

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
            '어떤 일을 하시나요?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),

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

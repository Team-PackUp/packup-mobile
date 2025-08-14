import 'package:flutter/material.dart';
import 'package:packup/widget/guide/application/self_intro_card.dart';

class GuideApplicationSelfIntroSection extends StatelessWidget {
  const GuideApplicationSelfIntroSection({
    super.key,
    required this.value,
    required this.onChanged,
    this.maxLength = 500,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: GuideApplicationSelfIntroCard(
        value: value,
        onChanged: onChanged,
        maxLength: maxLength,
      ),
    );
  }
}

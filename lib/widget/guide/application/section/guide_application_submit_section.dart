import 'package:flutter/material.dart';
import 'package:packup/widget/guide/application/submit_bar.dart';

class GuideApplicationSubmitSection extends StatelessWidget {
  const GuideApplicationSubmitSection({
    super.key,
    required this.enabled,
    required this.onSubmit,
  });
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return GuideApplicationSubmitBar(enabled: enabled, onSubmit: onSubmit);
  }
}

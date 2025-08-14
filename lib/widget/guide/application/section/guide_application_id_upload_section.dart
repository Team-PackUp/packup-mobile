import 'package:flutter/material.dart';
import 'package:packup/widget/guide/application/id_upload_card.dart';

class GuideApplicationIdUploadSection extends StatelessWidget {
  const GuideApplicationIdUploadSection({
    super.key,
    this.pickedFileName,
    required this.onPickPressed,
  });

  final String? pickedFileName;
  final VoidCallback onPickPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: GuideApplicationIdUploadCard(
        pickedFileName: pickedFileName,
        onPickPressed: onPickPressed,
      ),
    );
  }
}

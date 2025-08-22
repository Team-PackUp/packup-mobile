import 'package:flutter/material.dart';
import 'package:packup/widget/reply/reply_card.dart';
import 'package:packup/widget/reply/reply_content_field.dart';
import 'package:packup/widget/reply/reply_section_title.dart';

class ReplyContentSection extends StatelessWidget {
  final TextEditingController controller;
  final int maxChars;

  const ReplyContentSection({
    super.key,
    required this.controller,
    required this.maxChars,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ReplySectionTitle('리뷰 작성'),
        ReplyCard(
          child: ReplyContentField(
            controller: controller,
            maxChars: maxChars,
          ),
        ),
      ],
    );
  }
}

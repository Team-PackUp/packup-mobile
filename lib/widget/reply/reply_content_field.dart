import 'package:characters/characters.dart';
import 'package:flutter/material.dart';

class ReplyContentField extends StatelessWidget {
  final TextEditingController controller;
  final int maxChars;

  const ReplyContentField({
    super.key,
    required this.controller,
    required this.maxChars,
  });

  @override
  Widget build(BuildContext context) {
    final counterStyle = TextStyle(fontSize: 12, color: Colors.grey.shade500);

    return Stack(
      children: [
        TextFormField(
          controller: controller,
          minLines: 6,
          maxLines: 12,
          maxLength: maxChars,
          decoration: const InputDecoration(
            hintText: '투어에 대한 자세한 리뷰를 작성해주세요. (최소 10자)',
            border: OutlineInputBorder(borderSide: BorderSide.none),
            filled: true,
            fillColor: Color(0xFFF7F8FA),
            counterText: '',
          ),
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) =>
                Text('${value.text.characters.length}/$maxChars', style: counterStyle),
          ),
        ),
      ],
    );
  }
}

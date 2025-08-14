import 'package:flutter/material.dart';

class GuideApplicationSelfIntroCard extends StatelessWidget {
  const GuideApplicationSelfIntroCard({
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
    final radius = BorderRadius.circular(12);
    InputDecoration deco(String hint) => InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: radius),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: Color(0xFF111827), width: 1.2),
      ),
      contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      counterText: "",
    );

    final controller = TextEditingController(text: value)
      ..selection = TextSelection.collapsed(offset: value.length);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "자기소개",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text("나를 소개해주세요", style: TextStyle(color: Color(0xFF6B7280))),
          const SizedBox(height: 12),
          Stack(
            children: [
              TextField(
                controller: controller,
                onChanged:
                    (v) => onChanged(
                      v.length > maxLength ? v.substring(0, maxLength) : v,
                    ),
                minLines: 5,
                maxLines: 8,
                maxLength: maxLength,
                decoration: deco("가이드로서 자신을 소개하고, 어떤 점이 특별한지 설명해주세요."),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Text(
                  "${controller.text.characters.length}/$maxLength",
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

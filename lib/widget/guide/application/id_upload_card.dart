import 'package:flutter/material.dart';
import 'package:packup/widget/guide/application/dashed_border_box.dart';

class GuideApplicationIdUploadCard extends StatelessWidget {
  const GuideApplicationIdUploadCard({
    super.key,
    this.pickedFileName,
    required this.onPickPressed,
  });
  final String? pickedFileName;
  final VoidCallback onPickPressed;

  @override
  Widget build(BuildContext context) {
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
            "신분증 업로드",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "신분증을 업로드해주세요.",
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 12),
          DashedBorderBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.upload_rounded,
                  size: 36,
                  color: Color(0xFFE85D8E),
                ),
                const SizedBox(height: 8),
                const Text(
                  "파일을 여기에 드래그 앤 드롭하거나",
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: onPickPressed,
                  child: const Text("파일 선택"),
                ),
                if (pickedFileName != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    pickedFileName!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

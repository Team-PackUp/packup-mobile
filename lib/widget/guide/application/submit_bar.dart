import 'package:flutter/material.dart';

class GuideApplicationSubmitBar extends StatelessWidget {
  const GuideApplicationSubmitBar({
    super.key,
    required this.enabled,
    required this.onSubmit,
  });
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: enabled ? onSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE85D8E),
              disabledBackgroundColor: const Color(0xFFF4B8CC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            child: const Text("정보 제출"),
          ),
        ),
      ),
    );
  }
}

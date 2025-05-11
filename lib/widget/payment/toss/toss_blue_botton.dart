// lib/widget/payment/toss/toss_blue_button.dart

import 'package:flutter/material.dart';

class TossBlueButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const TossBlueButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: Text(text),
    );
  }
}

// lib/widget/payment/toss/toss_payment_button.dart

import 'package:flutter/material.dart';

class TossPaymentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const TossPaymentButton({
    super.key,
    required this.onPressed,
    this.label = '결제하기',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
      ),
      child: Text(label),
    );
  }
}

import 'package:flutter/material.dart';

class ReplyCard extends StatelessWidget {
  final Widget child;
  const ReplyCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
        border: Border.all(color: const Color(0x11000000)),
      ),
      child: child,
    );
  }
}

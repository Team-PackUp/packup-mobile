import 'package:flutter/material.dart';

class IncludeItem extends StatelessWidget {
  final String text;

  const IncludeItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Row(
      children: [
        const Icon(Icons.check, size: 18, color: Colors.green),
        SizedBox(width: screenW * 0.02),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}

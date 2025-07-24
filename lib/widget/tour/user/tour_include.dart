import 'package:flutter/material.dart';

class TourInclude extends StatelessWidget {
  const TourInclude({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '포함 사항',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          IncludeItem(text: '전문 지역 가이드'),
          SizedBox(height: 8),
          IncludeItem(text: '소규모 그룹'),
        ],
      ),
    );
  }
}

class IncludeItem extends StatelessWidget {
  final String text;

  const IncludeItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check, size: 18, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}

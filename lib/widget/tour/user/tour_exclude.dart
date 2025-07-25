import 'package:flutter/material.dart';

class TourExclude extends StatelessWidget {
  const TourExclude({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '제외 사항',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          ExcludeItem(text: '음식과 음료'),
          SizedBox(height: 6),
          ExcludeItem(text: '특정 장소 입장료 (선택 사항)'),
        ],
      ),
    );
  }
}

class ExcludeItem extends StatelessWidget {
  final String text;

  const ExcludeItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.close, size: 18, color: Colors.redAccent),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

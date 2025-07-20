import 'package:flutter/material.dart';

class TimeCard extends StatelessWidget {
  final String dateText;
  final String time;
  final String price;
  final String subtitle;
  final String remainText;
  final bool isSelected;

  const TimeCard({
    super.key,
    required this.dateText,
    required this.time,
    required this.price,
    required this.subtitle,
    required this.remainText,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? Colors.black : Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF7F7F9),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dateText.isNotEmpty)
            Text(dateText, style: const TextStyle(fontWeight: FontWeight.w600)),
          if (dateText.isNotEmpty) const SizedBox(height: 8),
          Text(
            time,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(color: Colors.black54)),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              remainText,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

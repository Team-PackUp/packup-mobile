import 'package:flutter/material.dart';

class TimeCard extends StatelessWidget {
  final String dateText;
  final String time;
  final String price;
  final String subtitle;
  final String remainText;
  final bool isSelected;
  final VoidCallback? onTap;

  const TimeCard({
    super.key,
    required this.dateText,
    required this.time,
    required this.price,
    required this.subtitle,
    required this.remainText,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = isSelected ? Colors.black : const Color(0xFFE0E0E0);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dateText.isNotEmpty)
              Text(
                dateText,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            if (dateText.isNotEmpty) const SizedBox(height: 6),
            Text(
              time,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(price, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              remainText,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

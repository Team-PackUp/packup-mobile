import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivitySummarySection extends StatelessWidget {
  final double w;
  final double h;

  const ActivitySummarySection({super.key, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.calendar_today, 'label': '총 예약 건수', 'value': '2'},
      {'icon': Icons.favorite, 'label': '찜한 투어 수', 'value': '2'},
      {'icon': Icons.flight_takeoff, 'label': '다녀온 나라', 'value': '1'},
      {'icon': Icons.group, 'label': '함께한 가이드', 'value': '3'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('내 활동', style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.045)),
        SizedBox(height: h * 0.015),
        Row(
          children: items.map((item) {
            return Expanded(
              child: Column(
                children: [
                  Icon(item['icon'] as IconData, size: w * 0.07, color: Colors.pink),
                  SizedBox(height: h * 0.005),
                  Text(item['value'] as String,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.04)),
                  Text(item['label'] as String, style: TextStyle(fontSize: w * 0.03)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
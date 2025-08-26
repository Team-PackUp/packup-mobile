import 'package:flutter/material.dart';
import '../../../common/size_config.dart'; // context.sX / context.sY 확장 사용

class ActivitySummarySection extends StatelessWidget {
  const ActivitySummarySection({super.key});

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
        Text(
          '내 활동',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.sX(16), // 디자인 기준 약 16dp
          ),
        ),
        SizedBox(height: context.sY(10)), // 디자인 기준 약 10dp
        Row(
          children: items.map((item) {
            return Expanded(
              child: Column(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: context.sX(25), // 디자인 기준 약 25dp
                    color: Colors.pink,
                  ),
                  SizedBox(height: context.sY(4)), // 디자인 기준 약 4dp
                  Text(
                    item['value'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: context.sX(14), // 약 14dp
                    ),
                  ),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: context.sX(11), // 약 11dp
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

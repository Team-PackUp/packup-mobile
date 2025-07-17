import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecentReservationSection extends StatelessWidget {
  final double w;
  final double h;

  const RecentReservationSection({super.key, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': '경복궁 투어',
        'date': '2023년 10월 27일',
        'status': '예정됨',
        'statusColor': Colors.pink,
        'image': 'assets/image/background/daejeon.jpg'
      },
      {
        'title': '서울 길거리 음식 투어',
        'date': '2023년 11월 10일',
        'status': '완료됨',
        'statusColor': Colors.grey,
        'image': 'assets/image/background/jeonju.jpg'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text('최근 예약 내역',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.045))),
            Text('모두 보기', style: TextStyle(fontSize: w * 0.032, color: Colors.grey)),
          ],
        ),
        SizedBox(height: h * 0.015),
        ...items.map((item) {
          return GestureDetector(
            onTap: () {
              context.push('/tour/123');
            },
            child: Container(
              margin: EdgeInsets.only(bottom: h * 0.015),
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(w * 0.02),
                    child: Image.asset(
                      item['image'] as String,
                      width: w * 0.15,
                      height: w * 0.15,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'] as String,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.04),
                            overflow: TextOverflow.ellipsis),
                        SizedBox(height: h * 0.005),
                        Text(item['date'] as String,
                            style: TextStyle(fontSize: w * 0.03, color: Colors.grey),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  SizedBox(width: w * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.005),
                    decoration: BoxDecoration(
                      color: item['statusColor'] as Color,
                      borderRadius: BorderRadius.circular(w * 0.03),
                    ),
                    child: Text(
                      item['status'] as String,
                      style: TextStyle(fontSize: w * 0.028, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
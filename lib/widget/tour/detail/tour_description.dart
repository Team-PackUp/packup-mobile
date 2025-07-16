import 'package:flutter/material.dart';

class TourDescription extends StatelessWidget {
  const TourDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '설명',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),

          Text(
            '투어에서 인사동의 매력과 누리미디어가 있는 홍대입구역을 걸어보세요. '
            '주말만되면 사람이 엄청몰리지만 앉아서 사람구경하는것도 나름재밌습니다 이런것도 다 경험이죠.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.access_time, size: 20, color: Colors.black54),
              SizedBox(width: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '소요 시간: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '3시간'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.language, size: 20, color: Colors.black54),
              SizedBox(width: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '언어: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '영어, 한국어, 중국어'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

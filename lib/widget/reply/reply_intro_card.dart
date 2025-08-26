import 'package:flutter/material.dart';

class ReplyIntroCard extends StatelessWidget {
  const ReplyIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: Color(0xFF2D81FF)),
            SizedBox(width: 6),
            Text('여행은 어떠셨나요?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        SizedBox(height: 8),
        Text(
          '소중한 의견을 남겨주시면 다른 여행자들에게 큰 도움이 됩니다. 경험을 공유해주세요!',
          style: TextStyle(fontSize: 13, color: Color(0xFF667085)),
        ),
      ],
    );
  }
}

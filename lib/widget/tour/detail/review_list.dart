import 'package:flutter/material.dart';
import 'review_card.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '리뷰 (3)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('더보기', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const ReviewCard(
            name: 'Juna Im',
            imageUrl: 'https://i.pravatar.cc/150?img=5',
            rating: 5,
            content: '가이드가 개발자 출신이라 확실히 말이 잘 통하네요. 다음에도 이용예정입니다.',
            date: '2023-10-26',
          ),
          const ReviewCard(
            name: 'Minseok Park',
            imageUrl: 'https://i.pravatar.cc/150?img=10',
            rating: 2,
            content: '가이드가 영어를 잘 못하네요; 자바 잘한다고 써있는데 이건 뭔가요?',
            date: '2023-10-20',
          ),
        ],
      ),
    );
  }
}

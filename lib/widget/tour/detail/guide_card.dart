import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/tour/detail/rating.dart';
import 'package:packup/widget/tour/detail/tag.dart';

class GuideCard extends StatelessWidget {
  const GuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/guide/123');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
              radius: 30,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Joonmo Jeong',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Rating(rating: 4.1, reviewCount: 12),
                  const SizedBox(height: 8),
                  const Text(
                    "Chungnam National University Computer Science and Engineering department, Junior. Interested in robust backend Engineering.",
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: const [
                      Tag(label: 'Java'),
                      Tag(label: 'Javascript'),
                      Tag(label: 'Python'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:packup/widget/tour/detail/%08rating.dart';
import 'package:packup/widget/tour/detail/%08tag.dart';

class GuideProfileCard extends StatelessWidget {
  const GuideProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 프로필 상단
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(
                  'https://i.imgur.com/BoN9kdC.png',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Joonmo Jeong',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 6),
                    Rating(rating: 4.8, reviewCount: 37),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 소개글
          const Text(
            "리액트의 신 스프링의 신 얘는 그냥 개발을잘함;; The World Best Development Player jjm just legend. 팩업 투어쪽 설계 언제 끝나나요 빨리 끝나야 실제 데이터 연동 하는데 최대한 빨리 해야돼요 저 팩업 완성시키고 싶어요 파이팅",
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
          ),

          const SizedBox(height: 16),

          /// 언어 태그
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Tag(label: 'English'),
              Tag(label: 'Japanese'),
              Tag(label: 'Korean'),
            ],
          ),
        ],
      ),
    );
  }
}

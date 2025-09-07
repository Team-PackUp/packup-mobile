import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/theme/typographies/app_typographies.dart';
import 'package:packup/const/color.dart';
import 'package:packup/widget/home/reward_card.dart';

import '../../common/section_header.dart';

class RewardSection extends StatelessWidget {
  const RewardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final point = 413;
    final couponCount = 3;

    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: '🎁',
          title: '쿠폰',
          subTitle: '적립된 쿠폰으로 다양한 혜택을 누리세요',
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenH * 0.02),
          child: Row(
            children: [
              // Expanded(
              //   child: RewardCard(
              //     icon: Icons.monetization_on_outlined,
              //     title: '$point',
              //     subtitle: '포인트',
              //     description: '현재 보유 포인트',
              //   ),
              // ),
              SizedBox(height: screenH * 0.03),
              Expanded(
                child: RewardCard(
                  icon: Icons.percent,
                  title: '$couponCount개',
                  subtitle: '',
                  description: '사용 가능 쿠폰',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

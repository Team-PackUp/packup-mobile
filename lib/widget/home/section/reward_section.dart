import 'package:flutter/material.dart';
import 'package:packup/theme/typographies/app_typographies.dart';
import 'package:packup/const/color.dart';
import 'package:packup/widget/home/reward_card.dart';

class RewardSection extends StatelessWidget {
  const RewardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final point = 413;
    final couponCount = 3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎁 혜택 및 포인트',
            style: AppTypographies.get(
              size: AppFontSize.lg,
              weight: AppFontWeight.bold,
              color: TEXT_COLOR_B,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: RewardCard(
                  icon: Icons.monetization_on_outlined,
                  title: '$point',
                  subtitle: '포인트',
                  description: '현재 보유 포인트',
                ),
              ),
              const SizedBox(width: 12),
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
        ],
      ),
    );
  }
}

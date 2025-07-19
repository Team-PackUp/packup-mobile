import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/profile/state_card.dart';

class PointCouponSection extends StatelessWidget {
  final double w;
  final double h;

  const PointCouponSection({super.key, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.access_time,
            label: '현재 보유 포인트',
            value: '413 포인트',
            w: w,
            h: h,
          ),
        ),
        SizedBox(width: w * 0.04),
        Expanded(
          child: StatCard(
            icon: Icons.local_offer,
            label: '사용 가능 쿠폰',
            value: '3 개',
            w: w,
            h: h,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/profile/support_card.dart';

class SupportWaySection extends StatelessWidget {
  final double w;
  final double h;

  const SupportWaySection({required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SizedBox(height: h * 0.015),
        SupportCard(
          icon: Icons.email_outlined,
          title: '이메일 문의',
          subtitle: '상세한 문의는 이메일로 남겨주시면 답변드립니다.',
          w: w,
          h: h,
        ),
      ],
    );
  }
}
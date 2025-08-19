import 'package:flutter/material.dart';
import 'package:packup/widget/menu/guide_intro_card.dart';

class MenuIntroSection extends StatelessWidget {
  const MenuIntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GuideIntroCard(),
    );
  }
}

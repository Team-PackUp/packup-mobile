import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/home/home_banner_carousel.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenH * 0.01),
      child: HomeBannerCarousel(
        onTapBanner: (index) {
          context.push('/banner/$index');
        },
      ),
    );
  }
}

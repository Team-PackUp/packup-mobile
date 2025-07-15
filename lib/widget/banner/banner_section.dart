import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/banner/home_banner_carousel.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: HomeBannerCarousel(
        onTapBanner: (index) {
          context.push('/banner/$index');
        },
      ),
    );
  }
}

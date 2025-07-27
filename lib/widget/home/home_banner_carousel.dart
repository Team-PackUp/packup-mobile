import 'package:flutter/material.dart';
import 'package:packup/widget/banner/home_banner.dart';

class BannerItem {
  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonText;

  const BannerItem({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
}

class HomeBannerCarousel extends StatelessWidget {
  final void Function(int index) onTapBanner;

  const HomeBannerCarousel({super.key, required this.onTapBanner});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    final List<BannerItem> banners = [
      const BannerItem(
        imagePath: 'assets/image/background/seoul.jpg',
        title: '서울의 숨겨진 매력 발견하기',
        subtitle: '현지 가이드와 함께 특별한 추억을 만드세요!',
        buttonText: '내 근처 투어 탐색',
      ),
      const BannerItem(
        imagePath: 'assets/image/background/daejeon.jpg',
        title: '대전 과학도시 탐방',
        subtitle: '충남대학교 컴퓨터융합학부 정준모',
        buttonText: '만나러 가기',
      ),
      const BannerItem(
        imagePath: 'assets/image/background/busan.jpg',
        title: '이솔빈의 고향 부산',
        subtitle: '카이런소프트의 큰 별 이솔빈',
        buttonText: '팬미팅 참여',
      ),
    ];

    return SizedBox(
      height: screenH * .20,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: banners.length,
        padEnds: false,
        physics: const PageScrollPhysics(),
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Padding(
            padding: EdgeInsets.only(right: screenW * 0.02),
            child: HomeBanner(
              imagePath: banner.imagePath,
              title: banner.title,
              subtitle: banner.subtitle,
              buttonText: banner.buttonText,
              onTap: () => onTapBanner(index),
            ),
          );
        },
      ),
    );
  }
}

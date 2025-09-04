// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:packup/widget/banner/home_banner.dart';
// import '../../common/size_config.dart'; // sX/sY 사용 (없으면 제거)
//
// class BannerItem {
//   final String imagePath;
//   final String title;
//   final String subtitle;
//   final String buttonText;
//   final String regionCode;
//
//   const BannerItem({
//     required this.imagePath,
//     required this.title,
//     required this.subtitle,
//     required this.buttonText,
//     required this.regionCode,
//   });
// }
//
// class HomeBannerCarousel extends StatelessWidget {
//   final void Function(int index) onTapBanner;
//   final String regionCode;
//
//
//   const HomeBannerCarousel({super.key, required this.onTapBanner, required this.regionCode});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenW = MediaQuery.sizeOf(context).width;
//     final textScale = MediaQuery.textScaleFactorOf(context);
//
//     const vp = 0.9;
//     final itemWidth = screenW * vp;
//
//     final minH = context.sY(160, minScale: 0.9, maxScale: 1.2);
//     final baseH = math.max(minH, itemWidth * 0.45);
//     final bannerH = baseH * textScale.clamp(1.0, 1.15);
//
//     final List<BannerItem> banners = const [
//       // 11 서울
//       BannerItem(
//         imagePath: 'assets/image/background/seoul.jpg',
//         title: '서울의 숨겨진 매력 발견하기',
//         subtitle: '현지 가이드와 함께 특별한 추억을 만드세요!',
//         buttonText: '내 근처 투어 탐색',
//         regionCode: '11',
//       ),
//       // 26 부산
//       BannerItem(
//         imagePath: 'assets/image/background/busan.jpg',
//         title: '부산 바다와 미식 투어',
//         subtitle: '해운대부터 남포동까지, 바다와 음식의 도시',
//         buttonText: '부산 투어 둘러보기',
//         regionCode: '26',
//       ),
//       // 27 대구
//       BannerItem(
//         imagePath: 'assets/image/background/daegu.jpg',
//         title: '대구 근대 골목 산책',
//         subtitle: '근대문화 골목에서 즐기는 도심 힐링',
//         buttonText: '대구 투어 보기',
//         regionCode: '27',
//       ),
//       // 28 인천
//       BannerItem(
//         imagePath: 'assets/image/background/incheon.jpg',
//         title: '인천 차이나타운 & 개항장',
//         subtitle: '근대사와 이국적 풍경을 한 번에',
//         buttonText: '인천 투어 탐색',
//         regionCode: '28',
//       ),
//       // 29 광주
//       BannerItem(
//         imagePath: 'assets/image/background/gwangju.jpg',
//         title: '광주 예술 감성 충전',
//         subtitle: '비엔날레부터 미식까지 감각적인 하루',
//         buttonText: '광주 투어 보기',
//         regionCode: '29',
//       ),
//       // 30 대전
//       BannerItem(
//         imagePath: 'assets/image/background/daejeon.jpg',
//         title: '대전 과학도시 탐방',
//         subtitle: '엑스포과학공원부터 대청호 드라이브',
//         buttonText: '대전 투어 보기',
//         regionCode: '30',
//       ),
//       // 36 세종
//       BannerItem(
//         imagePath: 'assets/image/background/sejong.jpg',
//         title: '세종 호수공원 한바퀴',
//         subtitle: '도심 속 자연과 여유',
//         buttonText: '세종 투어 보기',
//         regionCode: '36',
//       ),
//       // 41 경기
//       BannerItem(
//         imagePath: 'assets/image/background/gyeonggi.jpg',
//         title: '경기도 당일치기 명소',
//         subtitle: '수원화성, 파주 감성카페, 양평 드라이브',
//         buttonText: '경기 투어 탐색',
//         regionCode: '41',
//       ),
//       // 42 강원
//       BannerItem(
//         imagePath: 'assets/image/background/gangwon.jpg',
//         title: '강원 산바다 힐링여행',
//         subtitle: '속초와 평창에서 즐기는 자연',
//         buttonText: '강원 투어 보기',
//         regionCode: '42',
//       ),
//       // 43 충북
//       BannerItem(
//         imagePath: 'assets/image/background/chungbuk.jpg',
//         title: '충북 속리산 & 청남대',
//         subtitle: '자연과 역사, 두 마리 토끼',
//         buttonText: '충북 투어 보기',
//         regionCode: '43',
//       ),
//       // 44 충남
//       BannerItem(
//         imagePath: 'assets/image/background/chungnam.jpg',
//         title: '충남 바다와 온천',
//         subtitle: '대천해수욕장과 덕산온천으로 힐링',
//         buttonText: '충남 투어 보기',
//         regionCode: '44',
//       ),
//       // 45 전북
//       BannerItem(
//         imagePath: 'assets/image/background/jeonbuk.jpg',
//         title: '전주 한옥마을 감성',
//         subtitle: '전통과 맛이 살아 숨 쉬는 골목',
//         buttonText: '전북 투어 보기',
//         regionCode: '45',
//       ),
//       // 46 전남
//       BannerItem(
//         imagePath: 'assets/image/background/jeonnam.jpg',
//         title: '여수밤바다 & 순천만',
//         subtitle: '낭만과 생태가 공존하는 도시',
//         buttonText: '전남 투어 보기',
//         regionCode: '46',
//       ),
//       // 47 경북
//       BannerItem(
//         imagePath: 'assets/image/background/gyeongbuk.jpg',
//         title: '경주 천년고도 산책',
//         subtitle: '불국사와 대릉원에서 만나는 역사',
//         buttonText: '경북 투어 보기',
//         regionCode: '47',
//       ),
//       // 48 경남
//       BannerItem(
//         imagePath: 'assets/image/background/gyeongnam.jpg',
//         title: '통영 & 거제 바다 여행',
//         subtitle: '섬과 바다가 만든 절경',
//         buttonText: '경남 투어 보기',
//         regionCode: '48',
//       ),
//       // 50 제주
//       BannerItem(
//         imagePath: 'assets/image/background/jeju.jpg',
//         title: '제주 올레길 완주 도전',
//         subtitle: '에메랄드 바다와 오름의 조화',
//         buttonText: '제주 투어 보기',
//         regionCode: '50',
//       ),
//     ];
//
//
//     return SizedBox(
//       height: bannerH,
//       child: PageView.builder(
//         controller: PageController(viewportFraction: vp),
//         itemCount: banners.length,
//         padEnds: false,
//         physics: const PageScrollPhysics(),
//         itemBuilder: (context, index) {
//           final banner = banners[index];
//           return Padding(
//             padding: EdgeInsets.only(right: context.sX(8, minScale: 0.9, maxScale: 1.2)),
//             child: HomeBanner(
//               imagePath: banner.imagePath,
//               title: banner.title,
//               subtitle: banner.subtitle,
//               buttonText: banner.buttonText,
//               onTap: () => onTapBanner(index),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

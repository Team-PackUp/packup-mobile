import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/alert_center/alert_center_provider.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/view/search/search.dart';
import 'package:packup/widget/banner/home_banner.dart';
import 'package:packup/widget/banner/home_banner_carousel.dart';
import 'package:packup/widget/common/alert_bell.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/search/category_filter.dart';
import 'package:packup/widget/search/search.dart';
import 'package:packup/widget/tour/tour_card.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';

import 'package:packup/model/tour/tour_model.dart';
import 'guide/edit/edit.dart';

/// 투어 목록 화면 (무한 스크롤 및 편집/추가 기능 포함)
class Tour extends StatelessWidget {
  const Tour({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourProvider(),
      child: const TourBody(),
    );
  }
}

/// 투어 목록을 그리는 Stateful 위젯
class TourBody extends StatefulWidget {
  const TourBody({super.key});

  @override
  State<TourBody> createState() => _TourBodyState();
}

class _TourBodyState extends State<TourBody> {
  // 스크롤 위치 추적을 위한 컨트롤러 (무한 스크롤 용도)
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 화면이 완전히 그려진 후 초기 투어 목록 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TourProvider>().getTourList();
    });

    // 스크롤 하단 도달 시 다음 페이지 데이터 요청
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        final provider = context.read<TourProvider>();
        if (provider.hasNextPage && !provider.isLoading) {
          provider.getTourList();
        }
      }
    });
  }

  /// ScrollController는 반드시 해제해야 메모리 누수 방지 가능
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TourProvider>();
    int alertCount = context.watch<AlertCenterProvider>().alertCount;
    final userProvider = context.watch<UserProvider>();
    final profileUrl = userProvider.userModel?.profileImagePath;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'PACKUP Explorer',
        arrowFlag: false,
        alert: AlertBell(
          count: alertCount,
          onTap: () async {
            context.push('/alert_center');
          },
        ),
        profile: CircleAvatar(
          backgroundImage:
              (profileUrl != null && profileUrl.isNotEmpty)
                  ? NetworkImage(profileUrl)
                  : null,
          radius: MediaQuery.of(context).size.height * 0.02,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearch(
              onTap: () {
                context.push("/search/all");
              },
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HomeBannerCarousel(
                onTapBanner: (index) {
                  context.push('/banner/$index');
                },
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CategoryFilter(
                onSelectionChanged: (selectedList) {
                  print('선택된 카테고리: $selectedList');
                },
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('🔥', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 6),
                      Text(
                        '인기 급상승 투어',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 350,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          provider.tourList.length +
                          (provider.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < provider.tourList.length) {
                          final tour = provider.tourList[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.45,
                                ),
                                child: TourCard(
                                  tour: tour,
                                  isFavorite: false,
                                  onTap: () {},
                                  onFavoriteToggle: () {},
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Placeholder(fallbackHeight: 100, color: Colors.blueGrey),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/profile/alert_center/alert_center_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/search_bar/custom_search_bar.dart';

import '../../provider/ai_recommend/ai_recommend_provider.dart';
import '../../provider/user/user_provider.dart';

import '../../widget/ai_recommend/category_chip.dart';
import '../../widget/ai_recommend/section.dart';
import '../../widget/ai_recommend/tour_card.dart';
import '../../model/ai_recommend/recommend_tour_model.dart';
import '../../widget/common/alert_bell.dart';

class AIRecommend extends StatelessWidget {
  static const routeName = 'ai_recommend';
  final String? redirect;

  const AIRecommend({super.key, this.redirect});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AIRecommendProvider(),
      child: AIRecommendContent(redirect: redirect),
    );
  }
}


class AIRecommendContent extends StatefulWidget {
  final String? redirect;

  const AIRecommendContent({super.key, this.redirect});

  @override
  State<AIRecommendContent> createState() => _AIRecommendContentState();
}

class _AIRecommendContentState extends State<AIRecommendContent> {
  late final AIRecommendProvider provider;
  late final AlertCenterProvider _alertCenterProvider;
  bool _redirectHandled = false;

  @override
  void initState() {
    super.initState();

    provider = context.read<AIRecommendProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _maybeRedirect();
      provider.initTour();
      provider.initPopular();
      _alertCenterProvider = context.read<AlertCenterProvider>();
      await _alertCenterProvider.initProvider();
    });
  }

  void _maybeRedirect() {
    if (_redirectHandled) return;

    final redirectPath = widget.redirect;
    if (redirectPath != null && redirectPath.isNotEmpty) {
      _redirectHandled = true;
      context.push(redirectPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AIRecommendProvider>();
    int alertCount = context.watch<AlertCenterProvider>().alertCount;
    final userProvider = context.watch<UserProvider>();
    final profileUrl = userProvider.userModel?.profileImagePath;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'AI 추천',
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

      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        children: [
          const CustomSearchBar(),
          const SizedBox(height: 16),
          // AI 추천 투어
          SectionHeader(icon: '🔥', title: 'AI가 추천하는 여행입니다!', onSeeMore: () {}),
          _TourList(
            tours: provider.tourList,
            onTap: (tour) {
              print("AI 추천 여행 클릭!!");
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => TourDetail(tourSeq: tour.seq),
              //   ),
              // );
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          // 카테고리
          SectionHeader(icon: '🔍', title: '종류별 탐색 진행', onSeeMore: () {}),
          // CategoryChips(categories: provider.categories),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          // 인기 투어
          SectionHeader(icon: '⭐', title: '인기 투어 모아보기', onSeeMore: () {}),
          _TourList(
            tours: provider.popular,
            onTap: (popular) {
              print("인기 투어 모아보기 클릭!!");
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ],
      ),
    );
  }
}

class _TourList extends StatelessWidget {
  final List<RecommendTourModel> tours;
  final ValueChanged<RecommendTourModel> onTap;

  const _TourList({super.key, required this.tours, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: MediaQuery.of(context).size.height * .3,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tours.length,
        separatorBuilder:
            (_, __) =>
                SizedBox(width: MediaQuery.of(context).size.width * .001),
        itemBuilder: (context, index) {
          final tour = tours[index];
          return InkWell(onTap: () => onTap(tour), child: TourCard(tour: tour));
        },
      ),
    );
  }
}

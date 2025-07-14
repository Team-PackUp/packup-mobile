import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/search/search.dart';

import '../../provider/ai_recommend/ai_recommend_provider.dart';
import '../../provider/alert_center/alert_center_provider.dart';
import '../../provider/user/user_provider.dart';

import '../../widget/ai_recommend/category_chip.dart';
import '../../widget/ai_recommend/section.dart';
import '../../widget/ai_recommend/tour_card.dart';
import '../../model/ai_recommend/recommend_tour_model.dart';
import '../../widget/common/alert_bell.dart';
import '../search/search.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<AIRecommendProvider>();
      _alertCenterProvider = context.read<AlertCenterProvider>();
      _maybeRedirect();
      provider.initTour(5);
      provider.initPopular(5);
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
          backgroundImage: (profileUrl != null && profileUrl.isNotEmpty)
              ? NetworkImage(profileUrl)
              : null,
          radius: MediaQuery.of(context).size.height * 0.02,
        ),
      ),
      body: Column(
        children: [
          CustomSearch(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Search()),
              );
            },
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              children: [
                SectionHeader(
                  icon: '🔥',
                  title: 'AI가 추천하는 여행입니다!',
                  callBackText: '더보기',
                  onSeeMore: () {
                    print("AI 추천 더보기");
                    context.push('/ai_recommend_detail');
                  },
                ),
                _TourList(
                  tours: provider.tourList,
                  onTap: (tour) {
                    print("AI 추천 여행 클릭!!");
                  },
                ),
                SectionHeader(
                  icon: '🔍',
                  title: '종류별 탐색 진행',
                  callBackText: '더보기',
                  onSeeMore: () {},
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                _TourList(
                  tours: provider.popular,
                  onTap: (popular) {
                    print("인기 투어 모아보기 클릭!!");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TourList extends StatelessWidget {
  final List<RecommendTourModel> tours;
  final ValueChanged<RecommendTourModel> onTap;

  const _TourList({required this.tours, required this.onTap});

  int _crossAxisCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 800) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = _crossAxisCount(width);

        const horizontalPadding = 8.0;
        final cardWidth = (width - (columns - 1) * horizontalPadding) / columns;

        return SizedBox(
          height: MediaQuery.of(context).size.height * .3,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tours.length,
            separatorBuilder: (_, __) => const SizedBox(width: horizontalPadding),
            itemBuilder: (context, index) {
              final tour = tours[index];
              return SizedBox(
                width: cardWidth,
                child: InkWell(
                  onTap: () => onTap(tour),
                  child: TourCard(tour: tour),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

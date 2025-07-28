import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/ai_recommend/recommend_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../provider/ai_recommend/ai_recommend_provider.dart';
import '../../../provider/alert_center/alert_center_provider.dart';
import '../../../provider/user/user_provider.dart';

import '../../../widget/common/alert_bell.dart';
import '../../../widget/common/circle_profile_image.dart';
import '../../../widget/common/custom_appbar.dart';
import '../../../widget/common/section_header.dart';
import '../../../widget/search/search.dart';

class AiRecommendDetail extends StatelessWidget {
  const AiRecommendDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AIRecommendProvider(),
      child: const AiRecommendDetailContent(),
    );
  }
}

class AiRecommendDetailContent extends StatefulWidget {
  const AiRecommendDetailContent({super.key});

  @override
  State<AiRecommendDetailContent> createState() => _AiRecommendDetailContentState();
}

class _AiRecommendDetailContentState extends State<AiRecommendDetailContent> {
  late final AIRecommendProvider provider;
  late final AlertCenterProvider _alertCenterProvider;

  @override
  void initState() {
    super.initState();
    provider = context.read<AIRecommendProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider.initTour(20);
      _alertCenterProvider = context.read<AlertCenterProvider>();
      await _alertCenterProvider.initProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recommendProvider = context.watch<AIRecommendProvider>();
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final isWide = screenW > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: 'AI 추천',
        arrowFlag: false,
        alert: AlertBell(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenW * 0.02,
              vertical: screenH * 0.01,
            ),
            child: CustomSearch(onTap: () => context.push('/search/all')),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenW * 0.03,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child: SectionHeader(
                icon: '🔥',
                title: 'AI가 추천하는 여행입니다!',
                onSeeMore: () {},
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: screenW * 0.03,
              vertical: MediaQuery.of(context).size.height * 0.005,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final tour = recommendProvider.tourList[index];
                  return RecommendCard(tour: tour);
                },
                childCount: recommendProvider.tourList.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 3 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

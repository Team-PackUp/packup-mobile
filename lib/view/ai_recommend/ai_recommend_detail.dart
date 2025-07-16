import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/ai_recommend/recommend_list.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/search/search.dart';

import '../../provider/ai_recommend/ai_recommend_provider.dart';
import '../../provider/alert_center/alert_center_provider.dart';
import '../../provider/user/user_provider.dart';

import '../../widget/ai_recommend/section.dart';
import '../../widget/common/alert_bell.dart';
import '../../widget/common/custom_sliver_appbar.dart';

class AiRecommendDetail extends StatelessWidget {

  const AiRecommendDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AIRecommendProvider(),
      child: AiRecommendDetailContent(),
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
    final alertCount       = context.watch<AlertCenterProvider>().alertCount;
    final profileUrl       = context.watch<UserProvider>().userModel?.profileImagePath;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: 'AI 추천',
        arrowFlag: false,
        alert: AlertBell(
          count: alertCount,
          onTap: () => context.push('/alert_center'),
        ),
        profile: CircleAvatar(
          radius: MediaQuery.of(context).size.height * 0.02,
          backgroundImage: (profileUrl != null && profileUrl.isNotEmpty)
              ? NetworkImage(profileUrl)
              : null,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CustomSearch(onTap: () => context.push('/search/all')),
          ),
        ),
      ),

      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical:   MediaQuery.of(context).size.height * 0.01,
        ),
        children: [
          SectionHeader(
            icon: '🔥',
            title: 'AI가 추천하는 여행입니다!',
            onSeeMore: () {},
          ),
          RecommendList(
            tours: recommendProvider.tourList,
            onTap: (_) {},
          ),
        ],
      ),
    );
  }
}



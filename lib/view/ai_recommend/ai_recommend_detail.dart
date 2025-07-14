import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/search/search.dart';

import '../../provider/ai_recommend/ai_recommend_provider.dart';
import '../../provider/alert_center/alert_center_provider.dart';
import '../../provider/user/user_provider.dart';

import '../../widget/ai_recommend/section.dart';
import '../../widget/ai_recommend/tour_card.dart';
import '../../model/ai_recommend/recommend_tour_model.dart';
import '../../widget/common/alert_bell.dart';
import '../search/search.dart';

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
          CustomSearch(
            onTap: () {
              context.push("/search/ai");
            },
          ),
          const SizedBox(height: 16),
          // AI 추천 투어
          SectionHeader(
              icon: '🔥', title: 'AI가 추천하는 여행입니다!', 
              onSeeMore: () {
                print("AI 추천 더보기");
              }),
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
        ],
      ),
    );
  }
}

class _TourList extends StatelessWidget {
  final List<RecommendTourModel> tours;
  final ValueChanged<RecommendTourModel> onTap;

  const _TourList({required this.tours, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tours.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final tour = tours[index];
        return InkWell(
          onTap: () => onTap(tour),
          child: TourCard(tour: tour),
        );
      },
    );
  }
}



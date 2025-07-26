import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/section_header.dart';
import '../recommend_list.dart';
import '../../../provider/ai_recommend/ai_recommend_provider.dart';
import 'package:provider/provider.dart';

class AIRecommendTourSection extends StatelessWidget {
  const AIRecommendTourSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tourList = context.watch<AIRecommendProvider>().tourList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: '🔥',
          title: 'AI가 추천하는 여행입니다!',
          subTitle: '개인 맞춤형 여행 코스',
          callBackText: '더보기',
          onSeeMore: () => context.push('/ai_recommend_detail'),
        ),
        RecommendList(
          tours: tourList,
          onTap: (_) {},
        ),
      ],
    );
  }
}


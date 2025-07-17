import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../provider/ai_recommend/ai_recommend_provider.dart';
import '../recommend_list.dart';
import '../section.dart';

class AiRecommendTrendSection extends StatelessWidget {
  const AiRecommendTrendSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tourList = context.watch<AIRecommendProvider>().popular;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: '⚡',
          title: '따끈따끈, 방금 오픈한 여행지!',
          subTitle: '여행 버킷리스트에 방금 추가된 핫플',
          callBackText: '더보기',
          onSeeMore: () {},
        ),
        RecommendList(
          tours: tourList,
          onTap: (_) {},
        ),
      ],
    );
  }
}


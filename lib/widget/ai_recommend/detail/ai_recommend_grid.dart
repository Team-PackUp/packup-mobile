import 'package:flutter/material.dart';
import 'package:packup/widget/ai_recommend/recommend_card.dart';
import '../../../model/ai_recommend/recommend_tour_model.dart';
import '../section.dart';

class AiRecommendGrid extends StatelessWidget {
  final List<RecommendTourModel> tourList;
  final bool isWide;
  final VoidCallback? onSeeMore;

  const AiRecommendGrid({
    super.key,
    required this.tourList,
    required this.isWide,
    this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenW * 0.03,
              vertical: screenH * 0.01,
            ),
            child: SectionHeader(
              icon: '🔥',
              title: 'AI가 추천하는 여행입니다!',
              onSeeMore: onSeeMore ?? () {},
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.03,
            vertical: screenH * 0.005,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final tour = tourList[index];
                return RecommendCard(tour: tour);
              },
              childCount: tourList.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWide ? 3 : 2,
              crossAxisSpacing: screenW * 0.03,
              mainAxisSpacing: screenH * 0.015,
              childAspectRatio: 0.65,
            ),
          ),
        ),
      ],
    );
  }
}

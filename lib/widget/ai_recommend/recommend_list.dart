import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/ai_recommend/recommend_card.dart';

import '../../model/ai_recommend/recommend_tour_model.dart';

class RecommendList extends StatelessWidget {
  final List<RecommendTourModel> tours;
  final ValueChanged<RecommendTourModel> onTap;

  const RecommendList({required this.tours, required this.onTap});

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
                  child: RecommendCard(tour: tour),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

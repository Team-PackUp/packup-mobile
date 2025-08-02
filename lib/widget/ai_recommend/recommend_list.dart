import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/ai_recommend/recommend_card.dart';

import '../../const/const.dart';
import '../../model/ai_recommend/recommend_tour_model.dart';

class RecommendList extends StatelessWidget {
  final List<RecommendTourModel> tours;
  final ValueChanged<RecommendTourModel> onTap;

  const RecommendList({required this.tours, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: INDEX_TOUR_CARD_HEGIHT,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tours.length,
            itemBuilder: (context, index) {
              final tour = tours[index];
              return SizedBox(
                width: INDEX_TOUR_CARD_WIDTH,
                child: RecommendCard(tour: tour),
              );
            },
          ),
        );
      },
    );
  }
}

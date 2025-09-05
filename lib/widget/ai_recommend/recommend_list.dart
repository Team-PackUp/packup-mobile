import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/ai_recommend/recommend_card.dart';
import '../../model/ai_recommend/recommend_tour_model.dart';

class RecommendList extends StatelessWidget {
  final List<RecommendTourModel> tours;
  final ValueChanged<RecommendTourModel> onTap;

  const RecommendList({super.key, required this.tours, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) return const SizedBox.shrink();

    final screenW = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            tours.map((tour) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenW * 0.005),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenW * 0.6),
                  child: InkWell(
                    onTap: () => onTap(tour),
                    child: RecommendCard(tour: tour),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

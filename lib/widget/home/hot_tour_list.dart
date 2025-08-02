import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/widget/home/hot_tour_card.dart';

class HotTourList extends StatelessWidget {
  final List<TourModel> tours;
  final ValueChanged<TourModel> onTap;

  const HotTourList({required this.tours, required this.onTap});

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
                    child: HotTourCard(tour: tour),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

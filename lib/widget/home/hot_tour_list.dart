import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/widget/home/hot_tour_card.dart';

import '../../const/const.dart';

class HotTourList extends StatelessWidget {
  final List<TourModel> tours;
  final ValueChanged<TourModel> onTap;

  const HotTourList({required this.tours, required this.onTap});

  int _crossAxisCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 800) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) return const SizedBox.shrink();
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

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
                child: InkWell(
                  onTap: () => onTap(tour),
                  child: HotTourCard(tour: tour),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

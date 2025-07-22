import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/widget/home/hot_tour_card.dart';

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
        final width = constraints.maxWidth;
        final columns = _crossAxisCount(width);

        final cardWidth = (width - (columns - 1) * (screenW / 60)) / columns;

        return SizedBox(
          height: screenH * .32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tours.length,
            separatorBuilder: (_, __) => SizedBox(width: 0),
            itemBuilder: (context, index) {
              final tour = tours[index];
              return SizedBox(
                width: cardWidth,
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

import 'package:flutter/material.dart';
import 'package:packup/common/size_config.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/widget/guide/detail/guide_tour_card.dart';

class GuideTourList extends StatelessWidget {
  final List<TourModel> tours;
  final ValueChanged<TourModel> onTap;

  const GuideTourList({required this.tours, required this.onTap, super.key});

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
        final maxW = constraints.maxWidth;
        final cols = _crossAxisCount(maxW);

        final side = context
            .sX(16, minScale: 0.9, maxScale: 1.3)
            .clamp(12.0, 24.0); // 좌우 여백
        final gap = context
            .sX(12, minScale: 0.9, maxScale: 1.3)
            .clamp(8.0, 20.0); // 아이템 간격

        final listHeight = context
            .sY(220, minScale: 0.85, maxScale: 1.2)
            .clamp(160.0, 300.0);

        final trackW = maxW - side * 2;
        final cardW = (trackW - gap * (cols - 1)) / cols;

        return SizedBox(
          height: listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: side),
            itemCount: tours.length,
            separatorBuilder: (_, __) => SizedBox(width: gap),
            itemBuilder: (context, index) {
              final tour = tours[index];
              return SizedBox(
                width: cardW,
                child: InkWell(
                  onTap: () => onTap(tour),
                  child: GuideTourCard(tour: tour),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

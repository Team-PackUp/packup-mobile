import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/widget/home/guide_card.dart';

class GuideList extends StatelessWidget {
  const GuideList({super.key, required this.guides, required this.onTap});
  final List<GuideModelTemp> guides;
  final ValueChanged<GuideModelTemp> onTap;

  int _crossAxisCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 800) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = _crossAxisCount(width);

        final cardWidth = (width - (columns - 1) * (screenW / 60)) / columns;

        return SizedBox(
          height: screenH * .40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: guides.length,
            separatorBuilder: (_, __) => SizedBox(width: 0),
            itemBuilder: (context, index) {
              final guide = guides[index];
              return SizedBox(
                width: cardWidth,
                child: InkWell(
                  onTap: () => onTap(guide),
                  child: GuideCard(guide: guide),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

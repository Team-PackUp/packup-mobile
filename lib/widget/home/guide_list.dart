import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/widget/home/guide_card.dart';
import '../../common/size_config.dart';

class GuideList extends StatelessWidget {
  const GuideList({super.key, required this.guides, required this.onTap});
  final List<GuideModelTemp> guides;
  final ValueChanged<GuideModelTemp> onTap;

  @override
  Widget build(BuildContext context) {
    final minCardDesignWidth = 150.0;
    final spacingDesign = 12.0;
    final maxColumns = 6;

    final listHeight = context.sY(260, minScale: 0.9, maxScale: 1.3);
    final spacing = context.sX(spacingDesign, minScale: 0.9, maxScale: 1.2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final minCard = context.sX(
          minCardDesignWidth,
          minScale: 0.9,
          maxScale: 1.25,
        );

        int columns = (width / (minCard + spacing)).floor().clamp(
          1,
          maxColumns,
        );

        final totalSpacing = spacing * (columns - 1);
        final cardWidth = (width - totalSpacing) / columns;

        return SizedBox(
          height: listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: guides.length,
            separatorBuilder: (_, __) => SizedBox(width: spacing),
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

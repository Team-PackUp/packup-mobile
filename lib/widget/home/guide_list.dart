import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/widget/home/guide_card.dart';
import '../../common/size_config.dart'; // sX/sY, sw/sh 익스텐션

class GuideList extends StatelessWidget {
  const GuideList({super.key, required this.guides, required this.onTap});
  final List<GuideModelTemp> guides;
  final ValueChanged<GuideModelTemp> onTap;

  @override
  Widget build(BuildContext context) {
    // 디자인 기준 파라미터
    final minCardDesignWidth = 150.0; // 카드 최소 너비(dp)
    final spacingDesign = 12.0;       // 카드 간격(dp)
    final maxColumns = 6;             // 과도한 칼럼 방지

    // 리스트 높이(디자인 값) → 필요에 맞게 조정
    final listHeight = context.sY(260, minScale: 0.9, maxScale: 1.3);
    final spacing = context.sX(spacingDesign, minScale: 0.9, maxScale: 1.2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // 카드 최소폭(스케일 적용)
        final minCard = context.sX(minCardDesignWidth, minScale: 0.9, maxScale: 1.25);

        // (카드폭 + 간격) 기준으로 칼럼 수 산정
        int columns = (width / (minCard + spacing)).floor().clamp(1, maxColumns);

        // 가로폭에서 간격 제외 후 카드폭 계산
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

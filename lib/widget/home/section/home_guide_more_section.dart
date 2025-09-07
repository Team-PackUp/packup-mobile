import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_model.dart';
import 'package:packup/provider/guide/guide_provider.dart';
import 'package:packup/widget/home/guide_card.dart';
import 'package:provider/provider.dart';

import '../../../common/size_config.dart';

class HomeGuideMoreSection extends StatefulWidget {
  final bool isWide;

  const HomeGuideMoreSection({
    super.key,
    required this.isWide,
  });

  @override
  State<HomeGuideMoreSection> createState() => _HomeGuideMoreSectionState();
}

class _HomeGuideMoreSectionState extends State<HomeGuideMoreSection> {
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GuideProvider>().getGuideList(10);
    });
  }

  void _onScroll() {
    final p = context.read<GuideProvider>();
    final pos = _scroll.position;
    final nearBottom = pos.pixels >= pos.maxScrollExtent - 200;

    if (nearBottom && !p.isLoading) {
      p.getGuideList(10);
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guides = context.select<GuideProvider, List<GuideModel>>((p) => p.guideList);
    final isLoading = context.select<GuideProvider, bool>((p) => p.isLoading);

    final hPad = context.sX(12, minScale: .85, maxScale: 1.2);
    final vPad = context.sY(6,  minScale: .85, maxScale: 1.2);
    final gap  = context.sX(12, minScale: .85, maxScale: 1.2);
    final minTileWidth = context.sX(170, minScale: .9, maxScale: 1.25);

    final sw = context.sw;
    final usableWidth = math.max(0.0, sw - (hPad * 2));
    int cross = math.max(2, (usableWidth / (minTileWidth + gap)).floor());
    cross = math.min(cross, 6);
    if (widget.isWide && cross < 3) cross = 3;

    final childAspectRatio = 0.65 / math.min(context.textScale, 1.3);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cross,
              crossAxisSpacing: gap,
              mainAxisSpacing: gap,
              childAspectRatio: childAspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
                  (ctx, i) => GuideCard(guide: guides[i]),
              childCount: guides.length,
            ),
          ),

          SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: isLoading
                  ? Padding(
                padding: EdgeInsets.only(top: context.sY(16)),
                child: const Center(child: CircularProgressIndicator()),
              )
                  : Padding(
                padding: EdgeInsets.only(top: context.sY(16), bottom: context.sY(8)),
                child: const Center(child: Text('모두 확인했어요 완료')),
              )
            ),
          ),

          if (!isLoading && guides.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 48),
                child: Center(child: Text('투어가 없어요')),
              ),
            ),
        ],
      ),
    )._withController(_scroll);
  }
}


extension _AttachController on Widget {
  Widget _withController(ScrollController controller) {
    return Builder(
      builder: (context) {
        return this;
      },
    );
  }
}

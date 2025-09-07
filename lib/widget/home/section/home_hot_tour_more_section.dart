import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/tour/tour_provider.dart';
import '../../../model/tour/tour_model.dart';
import '../hot_tour_card.dart';
import '../../../common/size_config.dart';

class HomeHotTourMoreSection extends StatefulWidget {
  final bool isWide;
  final String regionCode;

  const HomeHotTourMoreSection({
    super.key,
    required this.isWide,
    required this.regionCode,
  });

  @override
  State<HomeHotTourMoreSection> createState() => _HomeHotTourMoreSectionState();
}

class _HomeHotTourMoreSectionState extends State<HomeHotTourMoreSection> {
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<TourProvider>().getTourList(
        regionCode: widget.regionCode,
        refresh: true,
      );
    });
  }

  void _onScroll() {
    final p = context.read<TourProvider>();
    final pos = _scroll.position;
    final nearBottom = pos.pixels >= pos.maxScrollExtent - 200;

    if (nearBottom && !p.isLoading && p.hasNextPage) {
      p.getTourList(regionCode: widget.regionCode);
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
    final tours = context.select<TourProvider, List<TourModel>>((p) => p.tourList);
    final isLoading = context.select<TourProvider, bool>((p) => p.isLoading);
    final hasNext = context.select<TourProvider, bool>((p) => p.hasNextPage);

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
                  (ctx, i) => HotTourCard(tour: tours[i]),
              childCount: tours.length,
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
                  : (!hasNext
                  ? Padding(
                padding: EdgeInsets.only(top: context.sY(16), bottom: context.sY(8)),
                child: const Center(child: Text('모두 확인했어요 완료')),
              )
                  : const SizedBox.shrink()),
            ),
          ),

          if (!isLoading && tours.isEmpty)
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

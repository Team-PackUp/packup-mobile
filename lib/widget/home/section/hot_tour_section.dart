import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:packup/widget/home/hot_tour_list.dart';
import 'package:provider/provider.dart';

import '../../common/section_header.dart';

class HotTourSection extends StatefulWidget {
  final String regionCode;
  const HotTourSection({super.key, required this.regionCode});

  @override
  State<HotTourSection> createState() => _HotTourSectionState();
}

class _HotTourSectionState extends State<HotTourSection> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // 무한스크롤의 책임을 섹션에게 전가
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      final provider = context.read<TourProvider>();

        provider.getTourList(regionCode: widget.regionCode);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tourList = context.watch<TourProvider>().tourList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: '🔥',
          title: '인기 급상승 투어!',
          subTitle: '여러 사람들이 신청하고 있어요',
        ),
        HotTourList(
          tours: tourList,
          onTap: (_) {
            context.push("/tour/123");
          },
        ),
      ],
    );
  }
}

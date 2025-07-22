import 'package:flutter/material.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:packup/widget/home/hot_tour_list.dart';
import 'package:packup/widget/home/section.dart';
import 'package:provider/provider.dart';

class HotTourSection extends StatefulWidget {
  const HotTourSection({super.key});

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

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          provider.hasNextPage &&
          !provider.isLoading) {
        provider.getTourList();
      }
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
        HotTourList(tours: tourList, onTap: (_) {}),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:packup/widget/tour/user/section/tour_description_section.dart';
import 'package:packup/widget/tour/user/section/tour_exclude_section.dart';
import 'package:packup/widget/tour/user/section/tour_header_section.dart';
import 'package:packup/widget/tour/user/section/tour_include_section.dart';

import '../../../widget/common/custom_appbar.dart';

class TourDetail extends StatefulWidget {
  final int tourSeq;
  const TourDetail({super.key, required this.tourSeq});

  @override
  State<TourDetail> createState() => _TourDetailState();
}

class _TourDetailState extends State<TourDetail> {
  late final TourProvider _provider;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _provider = TourProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _loaded) return;
      _loaded = true;
      await _provider.getTourDetail(tourSeq: widget.tourSeq);
      if (!mounted) return;
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    // 🔹 먼저 Provider를 트리에 주입
    return ChangeNotifierProvider<TourProvider>.value(
      value: _provider,
      child: Consumer<TourProvider>(
        builder: (_, p, __) {
          final tour = p.tour;

          if (tour == null) {
            return const Scaffold(
              appBar: CustomAppbar(title: '투어가 존재하지 않습니다.'),
              body: SizedBox.shrink(),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppbar(title: tour.title),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TourHeaderSection(tour: tour),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // const TourGuideSection(),
                        SizedBox(height: screenH * 0.03),
                        TourDescriptionSection(tour: tour),
                        SizedBox(height: screenH * 0.03),
                        TourIncludeSection(tour: tour),
                        SizedBox(height: screenH * 0.03),
                        TourExcludeSection(tour: tour),
                        SizedBox(height: screenH * 0.03),
                        // const ReviewListSection(seq: 4),
                        SizedBox(height: screenH * 0.03),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

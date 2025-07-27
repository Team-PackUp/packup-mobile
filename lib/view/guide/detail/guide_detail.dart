import 'package:flutter/material.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:packup/widget/guide/detail/section/guide_profile_section.dart';
import 'package:packup/widget/guide/detail/section/guide_review_summary_section.dart';
import 'package:packup/widget/guide/detail/section/guide_tour_section.dart';
import 'package:packup/widget/guide/detail/section/review_list_section.dart';
import 'package:packup/widget/tour/user/review_list.dart';
import 'package:provider/provider.dart';

import '../../../widget/common/custom_appbar.dart';

class GuideDetailPage extends StatelessWidget {
  final int guideId;

  const GuideDetailPage({super.key, required this.guideId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourProvider(),
      child: GuideDetailContent(),
    );
  }
}

class GuideDetailContent extends StatefulWidget {
  const GuideDetailContent({super.key});

  @override
  State<GuideDetailContent> createState() => _GuideDetailContentState();
}

class _GuideDetailContentState extends State<GuideDetailContent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tourProvider = context.read<TourProvider>();

      tourProvider.getTourList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppbar(title: 'Guide Details'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.03,
            vertical: screenH * 0.01,
          ),
          children: [
            const GuideProfileSection(),
            SizedBox(height: screenH * 0.03),
            const GuideTourSection(),
            SizedBox(height: screenH * 0.03),
            const GuideReviewSummarySection(),
            SizedBox(height: screenH * 0.03),
            ReviewListSection(seq: 4),
            SizedBox(height: screenH * 0.03),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:packup/widget/guide/detail/section/guide_profile_section.dart';
import 'package:packup/widget/guide/detail/section/guide_tour_section.dart';

import '../../../widget/common/custom_appbar.dart';

class GuideDetailPage extends StatelessWidget {
  final int guideSeq;
  const GuideDetailPage({super.key, required this.guideSeq});

  @override
  Widget build(BuildContext context) {
    return GuideDetailContent(guideSeq: guideSeq);
  }
}

class GuideDetailContent extends StatelessWidget {
  final int guideSeq;
  const GuideDetailContent({super.key, required this.guideSeq});

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
            GuideProfileSection(guideSeq: guideSeq),
            SizedBox(height: screenH * 0.03),
            GuideTourSection(guideSeq: guideSeq),
            SizedBox(height: screenH * 0.03),
            // GuideReviewSummarySection(guideSeq: guideSeq),
            SizedBox(height: screenH * 0.03),
            // ReviewListSection(seq: guideSeq),
            SizedBox(height: screenH * 0.03),
          ],
        ),
      ),
    );
  }
}

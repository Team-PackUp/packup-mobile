import 'package:flutter/material.dart';
import 'package:packup/widget/guide/detail/guide_profile_card.dart';
import 'package:packup/widget/guide/detail/review_summary.dart';
import 'package:packup/widget/guide/detail/section/guide_profile_section.dart';
import 'package:packup/widget/guide/detail/tour_detail.dart';
import 'package:packup/widget/tour/detail/review_list.dart';

import '../../../widget/common/custom_appbar.dart';

class GuideDetailPage extends StatelessWidget {
  final int guideId;

  const GuideDetailPage({super.key, required this.guideId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Guide Details'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            GuideProfileSection(),
            SizedBox(height: 24),
            TourDetail(),
            SizedBox(height: 24),
            ReviewSummary(),
            SizedBox(height: 24),
            ReviewList(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

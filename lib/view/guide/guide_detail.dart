import 'package:flutter/material.dart';
import 'package:packup/widget/guide/guide_profile_card.dart';
import 'package:packup/widget/guide/review_summary.dart';
import 'package:packup/widget/guide/tour_detail.dart';
import 'package:packup/widget/tour/detail/review_list.dart';

class GuideDetailPage extends StatelessWidget {
  final int guideId;

  const GuideDetailPage({super.key, required this.guideId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide Details'),
        leading: const BackButton(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            GuideProfileCard(),
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

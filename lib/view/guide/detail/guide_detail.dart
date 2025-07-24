import 'package:flutter/material.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:packup/widget/guide/detail/review_summary.dart';
import 'package:packup/widget/guide/detail/section/guide_profile_section.dart';
import 'package:packup/widget/guide/detail/section/guide_tour_section.dart';
import 'package:packup/widget/tour/detail/review_list.dart';
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
    return Scaffold(
      appBar: CustomAppbar(title: 'Guide Details'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            GuideProfileSection(),
            SizedBox(height: 24),
            GuideTourSection(),
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

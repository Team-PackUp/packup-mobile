import 'package:flutter/material.dart';
import 'package:packup/widget/guide/guide_profile_card.dart';

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
            // TourHighlightSection(),
            SizedBox(height: 24),
            // ItinerarySection(),
          ],
        ),
      ),
    );
  }
}

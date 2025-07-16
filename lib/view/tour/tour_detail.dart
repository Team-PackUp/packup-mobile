import 'package:flutter/material.dart';
import 'package:packup/widget/tour/detail/guide_card.dart';
import 'package:packup/widget/tour/detail/%08rating.dart';
import 'package:packup/widget/tour/detail/tour_description.dart';
import 'package:packup/widget/tour/detail/tour_tag.dart';
import 'package:packup/widget/tour/detail/tour_include.dart';

class TourDetailPage extends StatelessWidget {
  const TourDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('인사동 & 북촌 걷기 투어'),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/image/background/jeonju.jpg',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '인사동 & 북촌 걷기 투어',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),
                  Rating(rating: 4.8, reviewCount: 150),
                  SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TourTag(label: 'Culture'),
                      TourTag(label: 'History'),
                      TourTag(label: 'Walking Tour'),
                      TourTag(label: 'Seoul'),
                    ],
                  ),

                  SizedBox(height: 24),
                  GuideCard(),
                  SizedBox(height: 24),
                  TourDescription(),
                  SizedBox(height: 24),
                  TourInclude(),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '설명',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

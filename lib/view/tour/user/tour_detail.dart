import 'package:flutter/material.dart';
import 'package:packup/widget/tour/user/guide_card.dart';
import 'package:packup/widget/tour/user/rating.dart';
import 'package:packup/widget/tour/user/review_list.dart';
import 'package:packup/widget/tour/user/tour_description.dart';
import 'package:packup/widget/tour/user/tour_exclude.dart';
import 'package:packup/widget/tour/user/tour_footer.dart';
import 'package:packup/widget/tour/user/tag.dart';
import 'package:packup/widget/tour/user/tour_include.dart';

import '../../../widget/common/custom_appbar.dart';

class TourDetailPage extends StatelessWidget {
  const TourDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: '인사동 & 북촌 걷기 투어'),
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
                      Tag(label: 'Culture'),
                      Tag(label: 'History'),
                      Tag(label: 'Walking Tour'),
                      Tag(label: 'Seoul'),
                    ],
                  ),

                  SizedBox(height: 24),
                  GuideCard(),
                  SizedBox(height: 24),
                  TourDescription(),
                  SizedBox(height: 24),
                  TourInclude(),
                  SizedBox(height: 24),
                  TourExclude(),
                  SizedBox(height: 24),
                  ReviewList(),
                ],
              ),
            ),

            // const SizedBox(height: 60),
          ],
        ),
      ),
      bottomNavigationBar: const TourFooter(),
    );
  }
}

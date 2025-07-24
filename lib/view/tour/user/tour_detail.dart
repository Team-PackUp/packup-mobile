import 'package:flutter/material.dart';
import 'package:packup/widget/tour/user/guide_card.dart';
import 'package:packup/widget/tour/user/rating.dart';
import 'package:packup/widget/tour/user/review_list.dart';
import 'package:packup/widget/tour/user/section/tour_header_section.dart';
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
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TourHeaderSection(),
                  SizedBox(height: screenH * 0.03),
                  const GuideCard(),
                  SizedBox(height: screenH * 0.03),
                  const TourDescription(),
                  SizedBox(height: screenH * 0.03),
                  const TourInclude(),
                  SizedBox(height: screenH * 0.03),
                  const TourExclude(),
                  SizedBox(height: screenH * 0.03),
                  const ReviewList(),
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

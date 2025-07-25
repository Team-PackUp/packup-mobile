import 'package:flutter/material.dart';
import 'package:packup/widget/tour/user/section/tour_description_section.dart';
import 'package:packup/widget/tour/user/section/tour_exclude_section.dart';
import 'package:packup/widget/tour/user/section/tour_guide_section.dart';
import 'package:packup/widget/tour/user/section/tour_header_section.dart';
import 'package:packup/widget/tour/user/section/tour_include_section.dart';
import 'package:packup/widget/tour/user/tour_footer.dart';

import '../../../widget/common/custom_appbar.dart';

class TourDetailPage extends StatelessWidget {
  const TourDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: '인사동 & 북촌 걷기 투어'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TourHeaderSection(),
            const TourGuideSection(),
            const TourDescriptionSection(),
            const TourIncludeSection(),
            const TourExcludeSection(),
            SizedBox(height: screenH * 0.03),
            SizedBox(height: screenH * 0.03),
            SizedBox(height: screenH * 0.03),
            SizedBox(height: screenH * 0.03),
            SizedBox(height: screenH * 0.03),
          ],
        ),
      ),
      bottomNavigationBar: const TourFooter(),
    );
  }
}

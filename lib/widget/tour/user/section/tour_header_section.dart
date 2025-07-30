import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/widget/tour/user/tour_meta_card.dart';

import '../tour_image_list.dart';

class TourHeaderSection extends StatelessWidget {
  const TourHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tour = TourDetailModel.mock();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TourImageList(toursImageUrl: tour.imageUrl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TourMetaCard(tour: tour),
        ),
      ],
    );
  }
}

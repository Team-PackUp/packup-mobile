import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/widget/tour/user/tour_description.dart';

class TourDescriptionSection extends StatelessWidget {
  const TourDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tour = TourDetailModel.mock();

    return TourDescription(tour: tour);
  }
}

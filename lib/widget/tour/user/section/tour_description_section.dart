import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/widget/tour/user/tour_description.dart';

class TourDescriptionSection extends StatelessWidget {
  final TourDetailModel tour;
  const TourDescriptionSection({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {

    return TourDescription(tour: tour);
  }
}

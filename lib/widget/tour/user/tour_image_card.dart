import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';

class TourImageCard extends StatelessWidget {
  final TourDetailModel tour;

  const TourImageCard({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      tour.imageUrl,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

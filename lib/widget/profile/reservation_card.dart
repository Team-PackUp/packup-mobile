// 단일 카드
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/common/slide_text.dart';

import '../../Common/util.dart';
import '../../model/tour/tour_model.dart';

class ReservationCard extends StatelessWidget {
  final TourModel tour;
  final double w;
  final double h;

  const ReservationCard({
    super.key,
    required this.tour,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    final image = tour.titleImagePath ?? 'assets/image/logo/logo.png';
    final title = tour.tourTitle!;
    DateTime date = tour.tourStartDate!;
    final status = tour.tourStatusCode!;
    final statusColor = Colors.amber;

    return GestureDetector(
      onTap: () => context.push('/tour/${tour.seq}'),
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.015),
        padding: EdgeInsets.all(w * 0.03),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(w * 0.03),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(w * 0.02),
              child: Image.asset(
                image.isNotEmpty ? image : 'assets/image/logo/logo.png',
                width: w * 0.15,
                height: w * 0.15,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/image/logo/logo.png',
                    width: w * 0.15,
                    height: w * 0.15,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SlideText(
                    title: title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.04),
                  ),
                  SizedBox(height: h * 0.005),
                  Text(
                    convertToYmd(date),
                    style: TextStyle(fontSize: w * 0.03, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: w * 0.02),
            Container(
              padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.005),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: Text(
                status,
                style: TextStyle(fontSize: w * 0.028, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

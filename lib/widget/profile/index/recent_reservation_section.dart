import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/tour/tour_model.dart';

import '../../common/util_widget.dart';
import '../reservation_list.dart';

class RecentReservationSection extends StatelessWidget {
  final double w;
  final double h;
  final List<TourModel> tourList;

  const RecentReservationSection({super.key, required this.w, required this.h, required this.tourList});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text('최근 예약 내역',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.045))),
            CustomButton.textGestureDetector(
                context: context,
                onTap: () {
                  context.push("/reservation/list");
                },
                label: '모두보기'),
          ],
        ),
        SizedBox(height: h * 0.015),
        ReservationList(
          w: w,
          h: h,
          tourList: tourList,),
      ],
    );
  }
}
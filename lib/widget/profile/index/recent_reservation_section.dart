import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/tour/tour_model.dart';

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
            InkWell(
                onTap: () {
                  context.push("/reservation/list");
                },
                child: Text('모두 보기', style: TextStyle(fontSize: w * 0.032, color: Colors.grey))),
          ],
        ),
        SizedBox(height: h * 0.015),
        ReservationList(w: w, h: h, tourList: tourList,),
      ],
    );
  }
}
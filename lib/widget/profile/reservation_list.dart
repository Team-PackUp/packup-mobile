import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/widget/common/custom_empty_list.dart';
import 'package:packup/widget/profile/reservation_card.dart';

class ReservationList extends StatelessWidget {
  final List<TourModel> tourList;
  final ScrollController? scrollController;
  final double h;
  final double w;

  final bool scrollable;

  const ReservationList({
    super.key,
    required this.tourList,
    this.scrollController,
    required this.h,
    required this.w,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    if (tourList.isEmpty) {
      return const CustomEmptyList(
        message: '예약중인 투어가 존재 하지 않습니다.',
        icon: Icons.airplanemode_on_sharp,
      );
    }

    if (scrollable) {
      return ListView.builder(
        controller: scrollController,
        itemCount: tourList.length,
        itemBuilder: (context, index) {
          final tour = tourList[index];
          return Padding(
            padding: EdgeInsets.only(bottom: h * 0.012),
            child: GestureDetector(
              onTap: () => context.push('/tour/${tour.seq}'),
              child: ReservationCard(tour: tour, w: w, h: h),
            ),
          );
        },
      );
    } else {
      return Column(
        children: tourList.map((tour) {
          return Padding(
            padding: EdgeInsets.only(bottom: h * 0.012),
            child: GestureDetector(
              onTap: () => context.push('/tour/${tour.seq}'),
              child: ReservationCard(tour: tour, w: w, h: h),
            ),
          );
        }).toList(),
      );
    }
  }
}

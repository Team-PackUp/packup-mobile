import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:packup/widget/profile/reservation_list.dart';

import '../../../common/custom_empty_list.dart';
import '../../reservation_card.dart';

class ReservationManageSection extends StatelessWidget {
  const ReservationManageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tourProvider = context.watch<TourProvider>();
    final tourList = tourProvider.tourList;
    final isLoading = tourProvider.isLoading;

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    if (isLoading) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '모든 예약 내역',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: w * 0.045,
          ),
        ),
        SizedBox(height: h * 0.02),

        if (tourList.isEmpty)
          const CustomEmptyList(
            message: '예약 중인 투어가 존재하지 않습니다.',
            icon: Icons.airplanemode_on_sharp,
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tourList.length,
            padding: EdgeInsets.zero,
            itemBuilder: (ctx, idx) {
              final tour = tourList[idx];
              return Padding(
                padding: EdgeInsets.only(bottom: h * 0.012),
                child: GestureDetector(
                  onTap: () => context.push('/tour/${tour.seq}'),
                  child: ReservationCard(tour: tour, w: w, h: h),
                ),
              );
            },
          ),
      ],
    );
  }
}

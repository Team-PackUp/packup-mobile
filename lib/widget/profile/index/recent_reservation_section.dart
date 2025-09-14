import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../provider/tour/reservation/reservation_list_provider.dart';
import '../../common/util_widget.dart';
import '../reservation_list.dart';

class RecentReservationSection extends StatefulWidget {
  final double w;
  final double h;

  const RecentReservationSection({super.key, required this.w, required this.h});

  @override
  State<RecentReservationSection> createState() => _RecentReservationSectionState();
}

class _RecentReservationSectionState extends State<RecentReservationSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ReservationListProvider>().getBookingTourList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReservationListProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text('최근 예약 내역',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.w * 0.045))),
            CustomButton.textGestureDetector(
                context: context,
                onTap: () {
                  context.push("/reservation/list");
                },
                label: '모두보기'),
          ],
        ),
        SizedBox(height: widget.h * 0.015),
        ReservationList(
          w: widget.w,
          h: widget.h,
          tourList: provider.bookingTourList,
          scrollable: false,
        ),
      ],
    );
  }
}

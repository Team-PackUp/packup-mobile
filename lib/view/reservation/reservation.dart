import 'package:flutter/material.dart';
import 'package:packup/widget/reservation/section/reservation_header_section.dart';
import 'package:packup/widget/reservation/section/reservation_summary_section.dart';
import 'package:packup/widget/reservation/section/reservation_time_list_section.dart';

class ReservationPage extends StatelessWidget {
  const ReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ReservationHeaderSection(),

            const Expanded(
              child: SingleChildScrollView(child: ReservationTimeListSection()),
            ),

            const ReservationSummarySection(),
          ],
        ),
      ),
    );
  }
}

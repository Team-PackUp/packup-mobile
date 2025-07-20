import 'package:flutter/material.dart';
import 'package:packup/widget/reservation/section/reservation_header_section.dart';
import 'package:packup/widget/reservation/section/reservation_summary_section.dart';
import 'package:packup/widget/reservation/section/reservation_time_list_section.dart';

class ReservationPage extends StatelessWidget {
  final ScrollController scrollController;

  const ReservationPage({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                const ReservationHeaderSection(),

                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: const ReservationTimeListSection(),
                  ),
                ),
              ],
            ),
          ),

          const Positioned(
            top: 16,
            right: 16,
            child: Icon(Icons.close, size: 24),
          ),

          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ReservationSummarySection(),
          ),
        ],
      ),
    );
  }
}

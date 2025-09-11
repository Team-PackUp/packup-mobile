import 'package:flutter/material.dart';
import 'package:packup/provider/tour/reservation/reservation_provider.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/reservation/section/reservation_header_section.dart';
import 'package:packup/widget/reservation/section/reservation_summary_section.dart';
import 'package:packup/widget/reservation/section/reservation_time_list_section.dart';

class ReservationPage extends StatelessWidget {
  final ScrollController scrollController;

  final int tourSeq;
  final int pricePerPerson;
  final String? tourTitle;
  final bool privateAvailable;
  final int? privateMinPrice;

  const ReservationPage({
    super.key,
    required this.scrollController,
    required this.tourSeq,
    required this.pricePerPerson,
    this.tourTitle,
    this.privateAvailable = false,
    this.privateMinPrice,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => ReservationProvider(
            tourSeq: tourSeq,
            pricePerPerson: pricePerPerson,
            tourTitle: tourTitle,
            privateAvailable: privateAvailable,
            privateMinPrice: privateMinPrice,
          )..load(),
      child: Scaffold(
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
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24),
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ReservationSummarySection(),
            ),
          ],
        ),
      ),
    );
  }
}

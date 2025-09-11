import 'package:flutter/material.dart';
import 'package:packup/provider/tour/reservation/reservation_provider.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/reservation/section/reservation_header_section.dart';
import 'package:packup/widget/reservation/section/reservation_summary_section.dart';
import 'package:packup/widget/reservation/section/reservation_time_list_section.dart';

class ReservationPage extends StatelessWidget {
  final ScrollController scrollController;

  /// 예약하려는 투어 식별자
  final int tourSeq;

  /// 1인 기준 가격(원) - 투어 상세에서 받아와 주입
  final int pricePerPerson;

  const ReservationPage({
    super.key,
    required this.scrollController,
    required this.tourSeq,
    required this.pricePerPerson,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => ReservationProvider(
            tourSeq: tourSeq,
            pricePerPerson: pricePerPerson,
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

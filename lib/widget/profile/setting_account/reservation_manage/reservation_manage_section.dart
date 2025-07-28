import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';

import '../../reservation_list.dart';

class ReservationManageSection extends StatefulWidget {
  const ReservationManageSection({super.key});

  @override
  State<ReservationManageSection> createState() => _ReservationManageSectionState();
}

class _ReservationManageSectionState extends State<ReservationManageSection> {
  late final ScrollController _scrollController;
  late TourProvider _tourProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      _tourProvider.getTourList();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tourProvider = context.watch<TourProvider>();
    final tourList = tourProvider.tourList;
    final isLoading = tourProvider.isLoading;

    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    if (isLoading) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenW * 0.03,
        vertical: screenH * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '모든 예약 내역',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenW * 0.045,
            ),
          ),
          SizedBox(height: screenH * 0.02),
          Expanded(
            child: ReservationList(
              w: screenW,
              h: screenH,
              tourList: tourList,
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
    );
  }
}

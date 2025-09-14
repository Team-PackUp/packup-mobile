import 'package:flutter/material.dart';
import 'package:packup/common/size_config.dart';
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
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tourProvider = context.read<TourProvider>();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;

    if (pos.pixels >= pos.maxScrollExtent - 100) {
      if (_tourProvider.isLoading) return;
      _tourProvider.getBookingTourList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tourProvider = context.watch<TourProvider>();
    final tourList = tourProvider.bookingTourList;
    final isLoading = tourProvider.isLoading;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenW = MediaQuery.of(context).size.width;
        final screenH = MediaQuery.of(context).size.height;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenW * 0.03,
              vertical: screenH * 0.01,
            ),
            child: SizedBox(
              height: constraints.maxHeight,
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
                    child: Builder(
                      builder: (_) {
                        // 초기 로딩 스피너
                        if (isLoading && tourList.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        // 빈 상태
                        if (tourList.isEmpty) {
                          return const Center(child: Text('예약 내역이 없습니다.'));
                        }

                        // 실제 리스트
                        return ReservationList(
                          w: context.sX(350),
                          h: context.sY(500),
                          tourList: tourList,
                          scrollController: _scrollController,
                        );
                      },
                    ),
                  ),

                  if (isLoading && tourList.isNotEmpty) ...[
                    SizedBox(height: 8),
                    const Center(child: SizedBox(
                      width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2),
                    )),
                    SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

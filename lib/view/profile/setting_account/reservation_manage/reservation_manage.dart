import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:provider/provider.dart';

import '../../../../provider/alert_center/alert_center_provider.dart';
import '../../../../widget/common/alert_bell.dart';
import '../../../../widget/common/custom_appbar.dart';
import '../../../../widget/profile/setting_account/reservation_manage/reservation_manage_section.dart';

class ReservationManage extends StatelessWidget {
  const ReservationManage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TourProvider()),
      ],
      child: const ReservationManageContent(),
    );
  }

}

class ReservationManageContent extends StatefulWidget {
  const ReservationManageContent({super.key});

  @override
  State<ReservationManageContent> createState() => _ReservationManageContent();
}

class _ReservationManageContent extends State<ReservationManageContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TourProvider>().getTourList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final alertCount = context.watch<AlertCenterProvider>().alertCount;
    final isLoading = context.watch<TourProvider>().isLoading;
    final isLoading2 = context.watch<LoadingProvider>().isLoading;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppbar(
        arrowFlag: false,
        title: '마이페이지',
        alert: AlertBell(
          count: alertCount,
          onTap: () => context.push('/alert_center'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        children: [
          if (!isLoading && !isLoading2)
            const ReservationManageSection(),
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:provider/provider.dart';

import '../../../../widget/common/alert_bell.dart';
import '../../../../widget/common/custom_appbar.dart';
import '../../../../widget/profile/setting_account/reservation_manage/reservation_manage_section.dart';
import '../../../../widget/search/search.dart';

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

    return Scaffold(
        appBar: CustomAppbar(
          title: '나의 예정 여정',
          arrowFlag: false,
          alert: AlertBell(),
          bottom: CustomSearch(
              mode: SearchMode.input,
              hint: '제목이나 가이드 이름으로 검색',
              onChanged: (value) {
                context.read<TourProvider>().filterTourList(value);
              },
            ),
        ),
        body: const ReservationManageSection(),
    );
  }
}



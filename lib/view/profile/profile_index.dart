import 'package:flutter/material.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:provider/provider.dart';

import '../../common/size_config.dart'; // sX/sY, sw/sh 익스텐션
import '../../model/guide/guide_model.dart';
import '../../model/tour/tour_model.dart';
import '../../provider/alert_center/alert_center_provider.dart';
import '../../provider/profile/contact_center/faq_provider.dart';
import '../../provider/user/user_provider.dart';

import '../../widget/common/alert_bell.dart';
import '../../widget/common/custom_appbar.dart';
import '../../widget/profile/index/activity_summary_section.dart';
import '../../widget/profile/index/faq_section.dart';
import '../../widget/profile/index/point_coupon_section.dart';
import '../../widget/profile/index/profile_section.dart';
import '../../widget/profile/index/recent_reservation_section.dart';
import '../../widget/profile/index/setting_account_section.dart';
import '../../widget/profile/index/support_way_section.dart';

class ProfileIndex extends StatelessWidget {
  const ProfileIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FaqProvider()),
        ChangeNotifierProvider(create: (_) => TourProvider()),
      ],
      child: const ProfileIndexContent(),
    );
  }
}

class ProfileIndexContent extends StatefulWidget {
  const ProfileIndexContent({super.key});

  @override
  State<ProfileIndexContent> createState() => _ProfileIndexContentState();
}

class _ProfileIndexContentState extends State<ProfileIndexContent> {
  @override
  void initState() {
    super.initState();
    final faqProvider = context.read<FaqProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FAQ 초기화
      faqProvider..getFaqCategory()..getFaqList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProvider>().userModel;

    // 필요 시 섹션 위젯들에 전달할 화면 크기(논리 px)
    final screenW = context.sw;
    final screenH = context.sh;

    return Scaffold(
      appBar: CustomAppbar(
        arrowFlag: false,
        title: '마이페이지',
        alert: const AlertBell(),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: context.sX(14.4)),
        children: [
          SizedBox(height: context.sY(10)),
          ProfileSection(userName: profile?.nickname ?? '익명', w: screenW, h: screenH),
          SizedBox(height: context.sY(20)),
          ActivitySummarySection(),
          SizedBox(height: context.sY(20)),
          RecentReservationSection(w: context.sX(350), h: context.sY(500)),
          SizedBox(height: context.sY(20)),
          PointCouponSection(w: screenW, h: screenH),
          SizedBox(height: context.sY(20)),
          SettingAccountSection(),
          SizedBox(height: context.sY(20)),
          SupportWaySection(w: screenW, h: screenH),
          SizedBox(height: context.sY(28)),
          const FaqSection(),
          SizedBox(height: context.sY(28)),
        ],
      ),
    );
  }
}

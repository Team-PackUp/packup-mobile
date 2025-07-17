import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/alert_center/alert_center_provider.dart';
import '../../provider/profile/contact_center/faq_provider.dart';
import '../../provider/user/user_provider.dart';

import '../../widget/common/alert_bell.dart';
import '../../widget/common/custom_appbar.dart';
import '../../widget/profile/section/activity_summary_section.dart';
import '../../widget/profile/section/faq_section.dart';
import '../../widget/profile/section/point_coupon_section.dart';
import '../../widget/profile/section/profile_section.dart';
import '../../widget/profile/section/recent_reservation_section.dart';
import '../../widget/profile/section/setting_account_section.dart';
import '../../widget/profile/section/support_way_section.dart';

class ProfileIndex extends StatelessWidget {
  const ProfileIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FaqProvider()),   // FAQ 프로바이더 주입
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
    final alertCount = context.watch<AlertCenterProvider>().alertCount;
    final profile = context.watch<UserProvider>().userModel;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
          SizedBox(height: h * 0.015),
          ProfileSection(userName: profile?.nickname ?? '익명', w: w, h: h),
          SizedBox(height: h * 0.03),
          ActivitySummarySection(w: w, h: h),
          SizedBox(height: h * 0.03),
          RecentReservationSection(w: w, h: h),
          SizedBox(height: h * 0.03),
          PointCouponSection(w: w, h: h),
          SizedBox(height: h * 0.03),
          SettingAccountSection(w: w, h: h),
          SizedBox(height: h * 0.03),
          SupportWaySection(w: w, h: h),
          SizedBox(height: h * 0.04),
          FaqSection(),
          SizedBox(height: h * 0.04),
        ],
      ),
    );
  }
}


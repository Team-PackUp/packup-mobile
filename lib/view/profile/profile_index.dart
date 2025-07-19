import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:provider/provider.dart';

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
    final tourProvider = context.read<TourProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FAQ 초기화
      faqProvider..getFaqCategory()..getFaqList();
      tourProvider.getTourList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final alertCount = context.watch<AlertCenterProvider>().alertCount;
    final profile = context.watch<UserProvider>().userModel;
    final tourList = context.watch<TourProvider>().tourList;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final List<TourModel> sampleTours = [
      TourModel(
        seq: 1,
        guide: GuideModel.empty(),
        minPeople: 2,
        maxPeople: 5,
        applyStartDate: DateTime.parse('2025-07-01'),
        applyEndDate: DateTime.parse('2025-07-10'),
        tourStartDate: DateTime.parse('2025-08-01'),
        tourEndDate: DateTime.parse('2025-08-07'),
        tourTitle: '부산 해안 투어',
        tourPrice: 50000,
        tourIntroduce: '부산의 아름다운 해안을 만끽하는 1박 2일 투어입니다.',
        tourStatusCode: '100001',
        tourStatusLabel: '모집중',
        tourLocation: '부산',
        titleImagePath: 'https://example.com/images/busan.jpg',
        createdAt: DateTime.parse('2025-06-15T10:00:00'),
        updatedAt: DateTime.parse('2025-06-20T15:30:00'),
      ),
      TourModel(
        seq: 2,
        guide: GuideModel.empty(),
        minPeople: 1,
        maxPeople: 10,
        applyStartDate: DateTime.parse('2025-07-05'),
        applyEndDate: DateTime.parse('2025-07-15'),
        tourStartDate: DateTime.parse('2025-08-15'),
        tourEndDate: DateTime.parse('2025-08-20'),
        tourTitle: '제주 올레길 트레킹',
        tourPrice: 100000,
        tourIntroduce: '제주의 올레길을 따라 걷는 힐링 트레킹 투어입니다.',
        tourStatusCode: '100002',
        tourStatusLabel: '마감임박',
        tourLocation: '제주도',
        titleImagePath: 'https://example.com/images/jeju.jpg',
        createdAt: DateTime.parse('2025-06-20T09:00:00'),
        updatedAt: DateTime.parse('2025-06-25T18:45:00'),
      ),
    ];

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
          RecentReservationSection(w: w, h: h, tourList: sampleTours),
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


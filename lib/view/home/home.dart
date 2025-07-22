import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/alert_center/alert_center_provider.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:provider/provider.dart';

import 'package:packup/widget/home/section/banner_section.dart';
import 'package:packup/widget/home/section/category_section.dart';
import 'package:packup/widget/home/section/hot_tour_section.dart';
import 'package:packup/widget/guide/guide_section.dart';
import 'package:packup/widget/profile/reward/reward_section.dart';
import 'package:packup/widget/search/search.dart';
import 'package:packup/widget/common/alert_bell.dart';
import 'package:packup/widget/common/custom_sliver_appbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourProvider(),
      child: const HomeContent(),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tourProvider = context.read<TourProvider>();
      final alertProvider = context.read<AlertCenterProvider>();

      tourProvider.getTourList();
      await alertProvider.initProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileUrl =
        context.watch<UserProvider>().userModel?.profileImagePath;
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder:
              (context, _) => [
                CustomSliverAppBar(
                  title: 'PACKUP Explorer',
                  arrowFlag: false,
                  alert: const AlertBell(),
                  profile: CircleAvatar(
                    radius: screenH * 0.02,
                    backgroundImage:
                        (profileUrl != null && profileUrl.isNotEmpty)
                            ? NetworkImage(profileUrl)
                            : null,
                  ),
                  bottom: CustomSearch(
                    onTap: () => context.push('/search/all'),
                  ),
                ),
              ],
          body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: screenW * 0.01,
              vertical: screenH * 0.01,
            ),
            children: const [
              SizedBox(height: 8),
              BannerSection(),
              SizedBox(height: 12),
              CategorySection(),
              SizedBox(height: 20),
              HotTourSection(),
              SizedBox(height: 20),
              GuideSection(),
              SizedBox(height: 20),
              RewardSection(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

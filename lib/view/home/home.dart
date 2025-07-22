import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/alert_center/alert_center_provider.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/widget/home/section/banner_section.dart';
import 'package:packup/widget/common/alert_bell.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/common/custom_sliver_appbar.dart';
import 'package:packup/widget/guide/guide_section.dart';
import 'package:packup/widget/profile/reward/reward_section.dart';
import 'package:packup/widget/search/category_section.dart';
import 'package:packup/widget/search/search.dart';
import 'package:packup/widget/tour/hot_tour_section.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourProvider(),
      child: HomeContent(),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late final TourProvider provider;
  late final AlertCenterProvider _alertCenterProvider;

  // 무한스크롤
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<TourProvider>();
      _alertCenterProvider = context.read<AlertCenterProvider>();
      context.read<TourProvider>().getTourList();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (provider.hasNextPage && !provider.isLoading) {
          provider.getTourList();
        }
      }
    });
  }

  // 메모리 leak
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileUrl =
        context.watch<UserProvider>().userModel?.profileImagePath;
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder:
              (context, _) => [
                CustomSliverAppBar(
                  title: 'PACKUP Explorer',
                  arrowFlag: false,
                  alert: AlertBell(),
                  profile: CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.02,
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
              horizontal: MediaQuery.of(context).size.width * 0.01,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            children: [
              SizedBox(height: screenH * 0.03),
              const BannerSection(),
              SizedBox(height: screenH * 0.03),
              const CategorySection(),
              SizedBox(height: screenH * 0.03),
              const HotTourSection(),
              SizedBox(height: screenH * 0.03),
              const GuideSection(),
              SizedBox(height: screenH * 0.03),
              const RewardSection(),
              SizedBox(height: screenH * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/ai_recommend/section/ai_recommend_category_section.dart';
import 'package:packup/widget/ai_recommend/section/ai_recommend_tour_section.dart';
import 'package:packup/widget/ai_recommend/section/ai_recommend_trend_section.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/search/search.dart';

import '../../provider/ai_recommend/ai_recommend_provider.dart';
import '../../provider/alert_center/alert_center_provider.dart';
import '../../provider/user/user_provider.dart';

import '../../widget/common/alert_bell.dart';
import '../../widget/common/custom_sliver_appbar.dart';

class AIRecommend extends StatelessWidget {
  static const routeName = 'ai_recommend';
  final String? redirect;

  const AIRecommend({super.key, this.redirect});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AIRecommendProvider(),
      child: AIRecommendContent(redirect: redirect),
    );
  }
}

class AIRecommendContent extends StatefulWidget {
  final String? redirect;

  const AIRecommendContent({super.key, this.redirect});

  @override
  State<AIRecommendContent> createState() => _AIRecommendContentState();
}

class _AIRecommendContentState extends State<AIRecommendContent> {
  late final AIRecommendProvider provider;
  late final AlertCenterProvider _alertCenterProvider;
  bool _redirectHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<AIRecommendProvider>();
      _alertCenterProvider = context.read<AlertCenterProvider>();
      _maybeRedirect();
      provider.initTour(5);
      provider.initPopular(5);
      await _alertCenterProvider.initProvider();
    });
  }

  void _maybeRedirect() {
    if (_redirectHandled) return;
    final redirectPath = widget.redirect;
    if (redirectPath != null && redirectPath.isNotEmpty) {
      _redirectHandled = true;
      context.push(redirectPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileUrl = context.watch<UserProvider>().userModel?.profileImagePath;
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              CustomSliverAppBar(
                title: 'AI 추천',
                arrowFlag: false,
                alert: AlertBell(),
                profile: CircleAvatar(
                  radius: screenH * 0.02,
                  backgroundImage: (profileUrl != null && profileUrl.isNotEmpty)
                      ? NetworkImage(profileUrl)
                      : null,
                ),
                bottom: CustomSearch(onTap: () => context.push('/search/all')),
              ),
            ],
            body: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: screenW * 0.03,
                vertical: screenH * 0.01,
              ),
              children: [
                SizedBox(height: screenH * 0.03),
                AIRecommendTourSection(),
                SizedBox(height: screenH * 0.03),
                AIRecommendCategorySection(),
                SizedBox(height: screenH * 0.03),
                AiRecommendTrendSection(),
                SizedBox(height: screenH * 0.03),
              ],
            ),
          ),
      ),
    );
  }
}

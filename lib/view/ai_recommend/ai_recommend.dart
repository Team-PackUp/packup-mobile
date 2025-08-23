import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/ai_recommend/section/ai_recommend_category_section.dart';
import 'package:packup/widget/ai_recommend/section/ai_recommend_tour_section.dart';
import 'package:packup/widget/ai_recommend/section/ai_recommend_trend_section.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/search/search.dart';

import '../../common/size_config.dart';
import '../../provider/ai_recommend/ai_recommend_provider.dart';
import '../../provider/alert_center/alert_center_provider.dart';

import '../../widget/common/alert_bell.dart';
import '../../widget/common/circle_profile_image.dart';
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
  late final AIRecommendProvider _aiRecommendProvider;
  late final AlertCenterProvider _alertCenterProvider;
  bool _redirectHandled = false;

  @override
  void initState() {
    super.initState();

    _aiRecommendProvider = context.read<AIRecommendProvider>();
    _alertCenterProvider = context.read<AlertCenterProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _maybeRedirect();
      _aiRecommendProvider.initTour(5);
      _aiRecommendProvider.initPopular(5);
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
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            CustomSliverAppBar(
              title: 'AI 추천',
              arrowFlag: false,
              alert: const AlertBell(),
              profile: CircleProfileImage(radius: context.sY(14)),
              bottom: CustomSearch(onTap: () => context.push('/search/all')),
            ),
          ],
          body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: context.sX(12),
              vertical: context.sY(8),
            ),
            children: [
              SizedBox(height: context.sY(12)),
              const AIRecommendTourSection(),
              SizedBox(height: context.sY(12)),
              const AIRecommendCategorySection(),
              SizedBox(height: context.sY(12)),
              const AiRecommendTrendSection(),
              SizedBox(height: context.sY(12)),
            ],
          ),
        ),
      ),
    );
  }
}

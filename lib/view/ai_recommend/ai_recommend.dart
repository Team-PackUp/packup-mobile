import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/search/search.dart';

import '../../provider/ai_recommend/ai_recommend_provider.dart';
import '../../provider/alert_center/alert_center_provider.dart';
import '../../provider/user/user_provider.dart';

import '../../widget/ai_recommend/recommend_list.dart';
import '../../widget/ai_recommend/section.dart';
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
    final recommendProvider = context.watch<AIRecommendProvider>();
    final alertCount = context.watch<AlertCenterProvider>().alertCount;
    final profileUrl = context.watch<UserProvider>().userModel?.profileImagePath;

    return Scaffold(
      body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              CustomSliverAppBar(
                title: 'AI 추천',
                arrowFlag: false,
                alert: AlertBell(
                  count: alertCount,
                  onTap: () => context.push('/alert_center'),
                ),
                profile: CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.02,
                  backgroundImage: (profileUrl != null && profileUrl.isNotEmpty)
                      ? NetworkImage(profileUrl)
                      : null,
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child:
                    CustomSearch(onTap: () => context.push('/search/all')),
                  ),
                ),
              ),
            ],
            body: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              children: [
                SectionHeader(
                  icon: '🔥',
                  title: 'AI가 추천하는 여행입니다!',
                  callBackText: '더보기',
                  onSeeMore: () => context.push('/ai_recommend_detail'),
                ),
                RecommendList(
                  tours: recommendProvider.tourList,
                  onTap: (_) {},
                ),
                SectionHeader(
                  icon: '🔍',
                  title: '종류별 탐색 진행',
                  callBackText: '더보기',
                  onSeeMore: () {},
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                RecommendList(
                  tours: recommendProvider.popular,
                  onTap: (_) {},
                ),
              ],
            ),
          ),
      ),
    );
  }
}

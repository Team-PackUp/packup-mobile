import 'package:flutter/material.dart';
import 'package:packup/provider/guide/guide_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/alert_center/alert_center_provider.dart';
import '../../provider/tour/tour_provider.dart';

import '../../widget/common/alert_bell.dart';
import '../../widget/common/custom_appbar.dart';
import '../../widget/common/section_header.dart';
import '../../widget/home/section/home_guide_more_section.dart';
import '../../widget/search/search.dart';

class HomeGuideMore extends StatelessWidget {
  const HomeGuideMore({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuideProvider.create(),
      child: HomeGuideMoreContent(),
    );
  }
}

class HomeGuideMoreContent extends StatefulWidget {
  const HomeGuideMoreContent({super.key});

  @override
  State<HomeGuideMoreContent> createState() => _HomeGuideMoreContentState();
}

class _HomeGuideMoreContentState extends State<HomeGuideMoreContent> {
  late final GuideProvider provider;
  late final String regionCode;
  late final AlertCenterProvider _alertCenterProvider;

  @override
  void initState() {
    super.initState();
    provider = context.read<GuideProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<GuideProvider>();

      provider.getGuideList(10);
      _alertCenterProvider = context.read<AlertCenterProvider>();
      await _alertCenterProvider.initProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final isWide = screenW > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: '인기 급상승 투어',
        alert: AlertBell(),
        bottom: CustomSearch(
          mode: SearchMode.input,
          hint: '가이드 이름으로 검색',
          onChanged: (value) {
            context.read<GuideProvider>().filterGuideList(value);
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenW * 0.03,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child: SectionHeader(
                icon: '🔥',
                title: 'AI가 추천하는 가이드 입니다!',
                onSeeMore: () {},
              ),
            ),
          ),
          HomeGuideMoreSection(
            isWide: isWide,
          ),
        ],
      ),
    );
  }
}

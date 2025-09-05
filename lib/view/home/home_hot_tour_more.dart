import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/alert_center/alert_center_provider.dart';
import '../../provider/tour/tour_provider.dart';

import '../../widget/common/alert_bell.dart';
import '../../widget/common/custom_appbar.dart';
import '../../widget/common/section_header.dart';
import '../../widget/home/section/home_hot_tour_more_section.dart';
import '../../widget/search/search.dart';

class HomeHotTourMore extends StatelessWidget {
  final String regionCode;
  const HomeHotTourMore({super.key, required this.regionCode});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourProvider(),
      child: HomeHotTourMoreContent(regionCode: regionCode),
    );
  }
}

class HomeHotTourMoreContent extends StatefulWidget {
  final String regionCode;
  const HomeHotTourMoreContent({super.key, required this.regionCode});

  @override
  State<HomeHotTourMoreContent> createState() => _HomeHotTourMoreContentState();
}

class _HomeHotTourMoreContentState extends State<HomeHotTourMoreContent> {
  late final TourProvider provider;
  late final String regionCode;
  late final AlertCenterProvider _alertCenterProvider;

  @override
  void initState() {
    super.initState();
    provider = context.read<TourProvider>();
    regionCode = widget.regionCode;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<TourProvider>();

      provider.getTourList(regionCode: regionCode);
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
                title: 'AI가 추천하는 여행입니다!',
                onSeeMore: () {},
              ),
            ),
          ),
          HomeHotTourMoreSection(
            isWide: isWide,
            regionCode: regionCode,
          ),
        ],
      ),
    );
  }
}

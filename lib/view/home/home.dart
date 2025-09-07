import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/common/size_config.dart';
import 'package:packup/provider/alert_center/alert_center_provider.dart';
import 'package:packup/provider/guide/guide_provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:provider/provider.dart';

import 'package:packup/widget/home/section/banner_section.dart';
import 'package:packup/widget/home/section/category_section.dart';
import 'package:packup/widget/home/section/hot_tour_section.dart';
import 'package:packup/widget/home/section/guide_section.dart';
import 'package:packup/widget/home/section/reward_section.dart';
import 'package:packup/widget/search/search.dart';
import 'package:packup/widget/common/alert_bell.dart';
import 'package:packup/widget/common/custom_sliver_appbar.dart';

import '../../common/util.dart';
import '../../model/common/code_mapping_model.dart';
import '../../provider/home/home_provider.dart';
import '../../widget/common/circle_profile_image.dart';
import '../../widget/common/custom_dropdown_button.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GuideProvider.create()),
        ChangeNotifierProvider(create: (_) => TourProvider()),
        // Tour/Guide를 HomeProvider에 주입
        ChangeNotifierProxyProvider2<TourProvider, GuideProvider, HomeProvider>(
          create: (_) => HomeProvider(),
          update: (_, tours, guides, home) {
            home ??= HomeProvider();
            home.bind(tours: tours, guides: guides);
            return home;
          },
        ),
      ],
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
  // 선택 지역은 변경 가능하므로 state로 유지
  String? _selectedCode;

  late final TourProvider tourProvider;
  late final AlertCenterProvider alertProvider;

  late final Future<String> _initFuture;

  final List<CodeMappingModel> regionList = [
    CodeMappingModel(code: '11', label: '서울특별시'),
    CodeMappingModel(code: '26', label: '부산광역시'),
    CodeMappingModel(code: '27', label: '대구광역시'),
    CodeMappingModel(code: '30', label: '대전광역시'),
    CodeMappingModel(code: '36', label: '세종특별자치시'),
    CodeMappingModel(code: '41', label: '경기도'),
    CodeMappingModel(code: '42', label: '강원특별자치도'),
    CodeMappingModel(code: '43', label: '충청북도'),
    CodeMappingModel(code: '44', label: '충청남도'),
    CodeMappingModel(code: '45', label: '전북특별자치도'),
    CodeMappingModel(code: '46', label: '전라남도'),
    CodeMappingModel(code: '47', label: '경상북도'),
    CodeMappingModel(code: '28', label: '인천광역시'),
    CodeMappingModel(code: '29', label: '광주광역시'),
    CodeMappingModel(code: '48', label: '경상남도'),
    CodeMappingModel(code: '50', label: '제주특별자치도'),
  ];

  @override
  void initState() {
    super.initState();
    _initFuture = _initData();
  }

  Future<String> _initData() async {
    final selectedCode = await getDefaultRegion();

    tourProvider = context.read<TourProvider>();
    alertProvider = context.read<AlertCenterProvider>();

    await alertProvider.initProvider();
    await tourProvider.getTourList(regionCode: selectedCode);

    return selectedCode;
  }

  Future<void> getTourByRegion({required String regionCode}) async {
    await tourProvider.getTourList(refresh: true, regionCode: regionCode);
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return FutureBuilder<String>(
      future: _initFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        final regionCode = _selectedCode ?? snap.data!;

        return Scaffold(
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, _) => [
                CustomSliverAppBar(
                  centerTitle: false,
                  arrowFlag: false,
                  titleWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonHideUnderline(
                        child: AppDropdownButton<String>(
                          value: regionCode,
                          items: regionList.map((r) {
                            return DropdownMenuItem<String>(
                              value: r.code,
                              child: Row(
                                children: [
                                  Text(r.label),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (code) {
                            if (code != null && code != _selectedCode) {
                              setState(() => _selectedCode = code);
                              saveDefaultRegion(_selectedCode!);

                              getTourByRegion(regionCode: code);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  alert: const AlertBell(),
                  profile: CircleProfileImage(radius: context.sY(14)),
                  bottom: CustomSearch(onTap: () => context.push('/search/all')),
                ),
              ],
              body: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenW * 0.03,
                  vertical: screenH * 0.01,
                ),
                children: [
                  SizedBox(height: screenH * 0.01),
                  BannerSection(regionCode: regionCode),
                  SizedBox(height: screenH * 0.02),
                  const CategorySection(),
                  SizedBox(height: screenH * 0.02),
                  HotTourSection(regionCode: regionCode,),
                  SizedBox(height: screenH * 0.02),
                  const GuideSection(),
                  SizedBox(height: screenH * 0.02),
                  const RewardSection(),
                  SizedBox(height: screenH * 0.02),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


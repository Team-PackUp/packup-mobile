import 'package:flutter/material.dart';
import 'package:packup/provider/tour/guide/tour_listing_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/tour/guide/listing/section/tour_info_listing_list_section.dart';
import 'package:provider/provider.dart';

class GuideListingInfoPage extends StatelessWidget {
  const GuideListingInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourListingProvider()..refresh(),
      child: Scaffold(
        appBar: const CustomAppbar(title: '리스팅', arrowFlag: false),
        body: const TourInfoListingListSection(),
      ),
    );
  }
}

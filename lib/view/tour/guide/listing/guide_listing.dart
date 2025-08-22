import 'package:flutter/material.dart';
import 'package:packup/provider/tour/guide/tour_listing_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/tour/guide/listing/section/tour_listing_list_section.dart';
import 'package:provider/provider.dart';

class GuideListingPage extends StatelessWidget {
  const GuideListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourListingProvider()..refresh(),
      child: Scaffold(
        appBar: const CustomAppbar(title: '리스팅'),
        body: const TourListingListSection(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // 신규 등록 라우팅
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

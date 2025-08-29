import 'package:flutter/material.dart';
import 'package:packup/widget/guide/listing/create/step_desc.dart';
import 'package:packup/widget/guide/listing/create/step_exclude.dart';
import 'package:packup/widget/guide/listing/create/step_include.dart';
import 'package:packup/widget/guide/listing/create/step_itinerary.dart';
import 'package:packup/widget/guide/listing/create/step_location_address.dart';
import 'package:packup/widget/guide/listing/create/step_location_pin.dart';
import 'package:packup/widget/guide/listing/create/step_photos.dart';
import 'package:packup/widget/guide/listing/create/step_price_basic.dart';
import 'package:packup/widget/guide/listing/create/step_price_premium.dart';
import 'package:packup/widget/guide/listing/create/step_title.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';
import 'package:packup/widget/guide/listing/create/step_intro.dart';
import 'package:packup/widget/guide/listing/create/step_location_search.dart';

class ListingCreatePage extends StatelessWidget {
  const ListingCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => ListingCreateProvider(
            steps: [
              ListingStepConfig(
                id: 'intro',
                title: '리스팅 등록',
                builder: (ctx) => const StepIntro(),
              ),
              ListingStepConfig(
                id: 'title',
                title: '투어 제목',
                builder: (_) => const StepTitle(),
              ),
              ListingStepConfig(
                id: 'desc',
                title: '투어 소개',
                builder: (_) => const StepDesc(),
              ),
              ListingStepConfig(
                id: 'include',
                title: '포함되는 항목',
                builder: (_) => const StepInclude(),
              ),
              ListingStepConfig(
                id: 'exclude',
                title: '포함되지 않는 항목',
                builder: (_) => const StepExclude(),
              ),
              ListingStepConfig(
                id: 'location',
                title: '장소',
                builder: (ctx) => const StepLocationSearch(),
              ),
              ListingStepConfig(
                id: 'addr',
                title: '위치 확인',
                builder: (_) => const StepLocationAddress(),
              ),
              ListingStepConfig(
                id: 'pin',
                title: '위치 확인',
                builder: (_) => const StepLocationPin(),
              ),
              ListingStepConfig(
                id: 'photos',
                title: '사진',
                builder: (_) => const StepPhotos(),
              ),
              ListingStepConfig(
                id: 'itinerary',
                title: '일정표',
                builder: (_) => const StepItinerary(),
              ),
              ListingStepConfig(
                id: 'price_basic',
                title: '요금',
                builder: (_) => const StepPriceBasic(),
              ),
              ListingStepConfig(
                id: 'price_premium',
                title: '요금',
                builder: (_) => const StepPricePremium(),
              ),
              ListingStepConfig(
                id: 'provision',
                title: '세부 정보',
                builder: (_) => const StepProvision(),
              ),
            ],
          ),
      child: const _Scaffold(),
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListingCreateProvider>();

    return Scaffold(
      appBar: CustomAppbar(title: p.current.title),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: p.current.builder(context)),
            const _BottomBar(),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListingCreateProvider>();
    final id = p.current.id;

    int _int(String key) => p.getField<int>(key) ?? 0;
    final basic = _int('pricing.basic');
    final premium = _int('pricing.premiumMin');
    final feeRate = p.getField<double>('pricing.feeRate') ?? 0.2; // 기본 20%

    final title = (p.getField<String>('basic.title') ?? '').trim();
    final desc = (p.getField<String>('basic.description') ?? '').trim();

    final canNextOnTitle = title.isNotEmpty && title.length <= 90;
    final canNextOnDesc = desc.isNotEmpty && desc.length >= 10;

    final canNextOnLocation =
        (p.getField<String>('meet.placeName')?.isNotEmpty ?? false);

    final photoFiles = p.getField<List>('photos.files');
    final localPaths = p.getField<List>('photos.localPaths');
    final photoCount = (photoFiles?.length ?? localPaths?.length ?? 0);
    final canNextOnPhotos = photoCount >= 5;

    final itinCount = p.getField<int>('itinerary.count') ?? 0;
    final canNextOnItinerary = itinCount >= 1;

    bool enabled = true;
    if (id == 'title') enabled = canNextOnTitle;
    if (id == 'desc') enabled = canNextOnDesc;
    if (id == 'location') enabled = canNextOnLocation;
    if (id == 'photos') enabled = canNextOnPhotos;
    if (id == 'itinerary') enabled = canNextOnItinerary;
    if (id == 'price_basic') enabled = basic > 0;
    if (id == 'price_premium') enabled = true;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child:
          id == 'intro'
              ? SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    p.start();
                    p.next();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('시작하기'),
                ),
              )
              : Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: id == 'price_premium' ? p.next : p.prev,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(id == 'price_premium' ? '건너뛰기' : '이전'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: enabled ? () => p.nextWithGuard() : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('다음'),
                    ),
                  ),
                ],
              ),
    );
  }
}

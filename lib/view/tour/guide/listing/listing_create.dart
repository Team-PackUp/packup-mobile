import 'package:flutter/material.dart';
import 'package:packup/widget/guide/listing/create/step_location_address.dart';
import 'package:packup/widget/guide/listing/create/step_location_pin.dart';
import 'package:packup/widget/guide/listing/create/step_photos.dart';
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
              ), // ✅ NEW
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

    final canNextOnLocation =
        (p.getField<String>('meet.placeName')?.isNotEmpty ?? false);

    final photoFiles = p.getField<List>('photos.files');
    final localPaths = p.getField<List>('photos.localPaths');

    final photoCount = (photoFiles?.length ?? localPaths?.length ?? 0);
    final canNextOnPhotos = photoCount >= 5;

    bool enabled = true;
    if (id == 'location') enabled = canNextOnLocation;
    if (id == 'photos') enabled = canNextOnPhotos;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child:
          id == 'intro'
              ? SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: p.next,
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
                      onPressed: p.prev,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('이전'),
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

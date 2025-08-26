import 'package:flutter/material.dart';
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
      // onStart 콜백 없이 스텝만 등록합니다.
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
    final isIntro = p.current.id == 'intro';
    final isLocation = p.current.id == 'location';

    // 장소 단계에서 "다음" 버튼 활성화 조건 (선택 여부)
    final canNextOnLocation =
        (p.getField<String>('meet.placeName')?.isNotEmpty ?? false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child:
          isIntro
              // 1) 인트로: 시작하기 → 다음 스텝
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
              // 2) 그 외 스텝: 이전/다음
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
                      onPressed:
                          (isLocation && !canNextOnLocation) ? null : p.next,
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

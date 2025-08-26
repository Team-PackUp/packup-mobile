import 'package:flutter/material.dart';
import 'package:packup/widget/guide/listing/create/step_intro.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

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
            ],
            onStart: () {
              // ✅ 추후 다른 단계 라우팅 연결 예정
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('다음 단계는 곧 연결됩니다.')));
            },
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
          children: [Expanded(child: p.current.builder(context)), _BottomBar()],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListingCreateProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: p.start,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('시작하기'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:packup/view/tour/guide/listing/listing_create.dart'; // guideListingSteps

class GuideListingInfoDetailPage extends StatelessWidget {
  const GuideListingInfoDetailPage({super.key, required this.listingId});
  final String listingId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) =>
              ListingCreateProvider(steps: guideListingSteps)
                ..start()
                ..loadForEdit(listingId),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListingCreateProvider>();

    return Scaffold(
      appBar: CustomAppbar(title: p.current.title, arrowFlag: true),
      body: SafeArea(
        child:
            p.loadingDetail
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    // 🔑 현재 선택된 스텝 위젯을 그대로 렌더링
                    Expanded(child: p.current.builder(context)),
                  ],
                ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 48,
            child: FilledButton.icon(
              icon: const Icon(Icons.save_outlined),
              label: const Text('변경사항 저장'),
              onPressed: () async {
                await context.read<ListingCreateProvider>().submit();
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('저장되었습니다.')));
                  context.pop();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

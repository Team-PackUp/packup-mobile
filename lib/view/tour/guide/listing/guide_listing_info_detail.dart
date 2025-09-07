import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/guide/listing/create/step_review.dart';
import 'package:provider/provider.dart';
import 'package:packup/view/tour/guide/listing/listing_create.dart';

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

    final title = (p.getField<String>('basic.title') ?? '');
    final desc = (p.getField<String>('basic.description') ?? '');

    return Scaffold(
      appBar: const CustomAppbar(title: '리스팅 상세(수정 가능)', arrowFlag: true),
      body: SafeArea(
        child:
            (title.isEmpty && desc.isEmpty)
                ? const Center(child: CircularProgressIndicator())
                : const StepReview(),
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

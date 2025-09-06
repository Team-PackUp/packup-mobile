import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/guide/guide_provider.dart';
import 'package:packup/widget/common/custom_empty_list.dart';
import 'package:packup/widget/home/guide_list.dart';
import 'package:provider/provider.dart';

import '../../common/section_header.dart';

class GuideSection extends StatefulWidget {
  const GuideSection({super.key});
  @override
  State<GuideSection> createState() => _GuideSectionState();
}

class _GuideSectionState extends State<GuideSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuideProvider>().getGuideList(5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GuideProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) return const SizedBox.shrink();

        final guides = provider.guideList;
        if (guides.isEmpty) {
          return
          const CustomEmptyList(
              message: "추천 가능한 가이드가 존재하지 않습니다.", icon: Icons.question_mark
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: '🌟',
              title: '전문 가이드를 만나보세요!',
              subTitle: '믿을 수 있는 가이드와 함께해요',
              callBackText: '더보기',
            ),
            GuideList(
              guides: guides,
              onTap: (g) => context.push('/guide/${g.seq}'),
            ),
          ],
        );
      },
    );
  }
}

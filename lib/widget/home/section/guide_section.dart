import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/widget/home/guide_card.dart';
import 'package:packup/widget/home/guide_list.dart';

import '../../common/section_header.dart';

class GuideSection extends StatelessWidget {
  const GuideSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 가이드 데이터
    final guides = [
      {
        'name': '임준아',
        'desc': '플러터의신. 다음직장은 어디로갈것인가',
        'tours': 15,
        'image': 'https://i.pravatar.cc/150?img=3',
      },
      {
        'name': '박민석',
        'desc': '미국 거주 PRO 가이드 - 과제 따오는법도 알려줌',
        'tours': 12,
        'image': 'https://i.pravatar.cc/150?img=5',
      },
      {
        'name': '정준모',
        'desc': '행복해지고싶다',
        'tours': 10,
        'image': 'https://i.pravatar.cc/150?img=8',
      },
    ];

    final guideModels =
        guides.map((e) {
          return GuideModelTemp(
            name: e['name'] as String,
            desc: e['desc'] as String,
            tours: e['tours'] as int,
            image: e['image'] as String,
          );
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: '🌟',
          title: '전문 가이드를 만나보세요!',
          subTitle: '믿을 수 있는 가이드와 함께해요',
          callBackText: '더보기',
          onSeeMore: () => context.push('/index'),
        ),

        GuideList(guides: guideModels, onTap: (_) {}),
      ],
    );
  }
}

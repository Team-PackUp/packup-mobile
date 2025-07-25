import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/widget/home/guide_card.dart';
import 'package:packup/widget/home/guide_list.dart';
import 'package:packup/widget/home/section.dart';

class GuideSection extends StatelessWidget {
  const GuideSection({super.key});

  @override
  Widget build(BuildContext context) {
    final guides = [
      {
        'name': 'Juna Im',
        'desc': 'Flutter / PHP print("GOAT")',
        'tours': 15,
        'image':
            'https://i.imgur.com/kHJ7CsJ_d.webp?maxwidth=520&shape=thumb&fidelity=high',
      },
      {
        'name': '박민석',
        'desc': 'Chungbuk telecommunication master',
        'tours': 12,
        'image':
            'https://i.imgur.com/uLfUuwk_d.webp?maxwidth=520&shape=thumb&fidelity=high',
      },
      {
        'name': '정준모',
        'desc': 'Samsung Kakao Naver Lets go',
        'tours': 10,
        'image':
            'https://i.imgur.com/HVkGsb9_d.webp?maxwidth=520&shape=thumb&fidelity=high',
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

        GuideList(
          guides: guideModels,
          onTap: (_) {
            context.push('/guide/123');
          },
        ),
      ],
    );
  }
}

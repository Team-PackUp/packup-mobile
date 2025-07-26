import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ai_recommend/ai_recommend_category_model.dart';
import '../../../provider/ai_recommend/ai_recommend_provider.dart';
import '../../common/category_filter.dart';
import '../../common/section_header.dart';
import '../recommend_list.dart';


class AIRecommendCategorySection extends StatelessWidget {
  const AIRecommendCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final tourList = context.watch<AIRecommendProvider>().popular;

    final categories = [
      AIRecommendCategoryModel(name: '자연',        icon: Icons.park, seq: 1),             // 공원·트레킹
      AIRecommendCategoryModel(name: '역사·문화',  icon: Icons.account_balance, seq: 2),  // 유적·박물관
      AIRecommendCategoryModel(name: '미식 투어',   icon: Icons.restaurant, seq: 3),       // 로컬 맛집
      AIRecommendCategoryModel(name: '쇼핑',       icon: Icons.shopping_bag, seq: 4),     // 시장·아울렛
      AIRecommendCategoryModel(name: '액티비티',    icon: Icons.sports_handball, seq: 5),  // 익스트림·레저
      AIRecommendCategoryModel(name: '나이트라이프', icon: Icons.nightlife, seq: 6),       // 바·클럽
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: '🔍',
          title: '종류별로 탐색 하기!',
          subTitle: '종류별로 찾아 떠나는 여행',
          callBackText: '더보기',
          onSeeMore: () {},
        ),
        CategoryFilter<AIRecommendCategoryModel>(
          items: categories,
          labelBuilder: (c) => c.name,
          mode: SelectionMode.multiple,
          onSelectionChanged: (selectedCats) {
            final labels = selectedCats.map((c) => c.name).toList();
            print('선택된 카테고리: $labels');
          },
        ),
        RecommendList(
          tours: tourList,
          onTap: (_) {},
        ),
      ],
    );
  }
}


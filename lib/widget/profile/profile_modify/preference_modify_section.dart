import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/user/preference/preference_list.dart';

class PreferenceModifySection extends StatelessWidget {
  final Set<String> selected;
  final void Function(String category) toggleSelect;

  PreferenceModifySection({
    super.key,
    required this.selected,
    required this.toggleSelect,
  });

  final List<String> categories = [
    '기사', '책', '여행 가이드', '블로그', '시각 콘텐츠', '오디오 콘텐츠',
  ];

  final Map<String, String> categoryImageMap = {
    '기사': 'assets/image/preference/article.png',
    '책': 'assets/image/preference/article.png',
    '여행 가이드': 'assets/image/preference/article.png',
    '블로그': 'assets/image/preference/article.png',
    '시각 콘텐츠': 'assets/image/preference/article.png',
    '오디오 콘텐츠': 'assets/image/preference/article.png',
  };

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '선호 카테고리를 선택하세요',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: h * 0.02),
        Expanded(
          child: PreferenceList(
            categories: categories,
            selected: selected,
            toggleSelect: toggleSelect,
            categoryImageMap: categoryImageMap,
          ),
        ),
      ],
    );
  }
}

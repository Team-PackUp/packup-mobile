
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_empty_list.dart';
import 'package:provider/provider.dart';

import '../../../provider/user/user_provider.dart';
import '../../common/category_filter.dart';

class ProfileDetailSection extends StatelessWidget {
  const ProfileDetailSection({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    final user = context.watch<UserProvider>().userModel!;
    final List<String>? interests = user.preferCategorySeqJson;

    if(interests == null) {
      return CustomEmptyList(message: '선호하는 카테고리가 없습니다.', icon: Icons.room_preferences);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('관심사'),
        ),
        SizedBox(height: h * 0.02),
        CategoryFilter<String>(
            items: interests,
            labelBuilder: (c) => c,
            mode: SelectionMode.multiple,
            onSelectionChanged: (selectedCats) {
            final labels = selectedCats
                .map((c) => c.trim())   // for example
                .toList();
            print('선택된 카테고리: $labels');
            }
        ),
        SizedBox(height: h * 0.02),
        TextField(
          decoration: InputDecoration(
            hintText: '관심사 추가',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

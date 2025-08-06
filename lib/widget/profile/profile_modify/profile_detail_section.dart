
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/widget/common/custom_empty_list.dart';
import 'package:provider/provider.dart';

import '../../../provider/user/user_provider.dart';
import '../../common/category_filter.dart';
import '../../common/util_widget.dart';

class ProfileDetailSection extends StatefulWidget {
  const ProfileDetailSection({super.key});

  @override
  State<ProfileDetailSection> createState() => _ProfileDetailSectionState();
}

class _ProfileDetailSectionState extends State<ProfileDetailSection> {

  List<String>? _preference;
  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().userModel!;
    _preference = user.preferCategorySeqJson;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('관심사'),
        ),
        SizedBox(height: h * 0.02),
        if (_preference == null || _preference!.isEmpty)
          const CustomEmptyList(
            message: '선호하는 카테고리가 없습니다.',
            icon: Icons.room_preferences,
          )
        else
          CategoryFilter<String>(
            items: _preference!,
            labelBuilder: (c) => c,
            mode: SelectionMode.multiple,
            onSelectionChanged: (selectedCats) {
              final labels = selectedCats.map((c) => c.trim()).toList();
              print('선택된 카테고리: $labels');
            },
            readOnly: true,
          ),
        SizedBox(height: h * 0.02),
        CustomButton.textButton(
            context: context,
            onPressed: () async {
              final result = await context.push<List<String>>(
                '/profile/preference-modify',
                extra: _preference,
              );
              if (mounted && result != null) {
                setState(() {
                  _preference = result;
                });
              }

              print(result);
            },
            backgroundColor: PRIMARY_COLOR,
            label: '선호 카테고리 선택'
        )
      ],
    );
  }
}

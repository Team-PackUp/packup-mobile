
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
  final void Function(List<String>) preferenceChange;

  const ProfileDetailSection({super.key, required this.preferenceChange});

  @override
  State<ProfileDetailSection> createState() => _ProfileDetailSectionState();
}

class _ProfileDetailSectionState extends State<ProfileDetailSection> {
  final List<String> categories = [
    '기사',
    '책',
    '여행 가이드',
    '블로그',
    '시각 콘텐츠',
    '오디오 콘텐츠',
  ];
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
        CategoryFilter<String>(
          items: categories,
          initialSelectedItems: _preference,
          labelBuilder: (c) => c,
          mode: SelectionMode.multiple,
          onSelectionChanged: (selectedCats) {
            final labels = selectedCats.map((c) => c.trim()).toList();
            widget.preferenceChange(labels);
          },
        ),
        SizedBox(height: h * 0.02),
      ],
    );
  }
}

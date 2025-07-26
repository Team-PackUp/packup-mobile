import 'package:flutter/material.dart';
import 'package:packup/widget/profile/faq_list.dart';
import 'package:provider/provider.dart';

import '../../../model/profile/contact_center/faq_category_model.dart';
import '../../../provider/profile/contact_center/faq_provider.dart';
import '../../common/category_filter.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  void _changeFaqCategory(BuildContext context, FaqCategoryModel category) {
    context.read<FaqProvider>().filterByCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FaqProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryFilter<FaqCategoryModel>(
          items: provider.category,
          labelBuilder: (c) => c.codeName!,
          mode: SelectionMode.single,
          onSelectionChanged: (List<FaqCategoryModel> sel) {
            if (sel.isNotEmpty) {
              print(sel.first.codeName);
              _changeFaqCategory(context, sel.first);
            }
          },
        ),
        FaqList(key: UniqueKey(), faqList: provider.faqList),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/profile/contact_center/faq_category_model.dart';
import '../../../provider/profile/contact_center/faq_provider.dart';
import '../faq_card.dart';
import '../faq_category.dart';

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
        FaqCategory(
          categories: provider.category,
          onTapCategory: (category) => _changeFaqCategory(context, category),
        ),
        FaqCard(key: UniqueKey(), faqList: provider.faqList),
      ],
    );
  }
}


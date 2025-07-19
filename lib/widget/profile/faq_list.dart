import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/profile/contact_center/faq_model.dart';
import '../common/custom_empty_list.dart';
import 'faq_card.dart';

class FaqList extends StatelessWidget {
  final List<FaqModel> faqList;

  const FaqList({super.key, required this.faqList});

  @override
  Widget build(BuildContext context) {
    if (faqList.isEmpty) {
      return const CustomEmptyList(
        message: '등록된 질문이 없습니다.',
        icon: Icons.question_mark,
      );
    }

    return Column(
      children: faqList.map((faq) => FaqCard(faq: faq)).toList(),
    );
  }
}

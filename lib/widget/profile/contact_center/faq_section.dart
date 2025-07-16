import 'package:flutter/material.dart';
import 'package:packup/model/profile/contact_center/faq_model.dart';
import 'package:packup/widget/common/custom_empty_list.dart';
import 'package:packup/widget/profile/contact_center/faq_card.dart';

class FaqSection extends StatelessWidget {
  final List<FaqModel> faqList;

  const FaqSection({
    super.key,
    required this.faqList,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '자주 묻는 질문 (FAQ)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(height: height * 0.01),

        if(faqList.isEmpty)
          CustomEmptyList(message: 'FAQ 자료가 없습니다.', icon: Icons.question_mark)
        else
          ...faqList.map((faq) => FaqCard(
            key: UniqueKey(),
            question: faq.question!,
            answer:   faq.answer!,
          )),

        SizedBox(height: height * 0.03),
        Center(
          child: Column(
            children: [
              const Text('더 궁금한 점이 있으신가요?'),
              SizedBox(height: height * 0.005),
              GestureDetector(
                onTap: () {},
                child: Text(
                  '언제든지 고객센터에 문의해주세요.',
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

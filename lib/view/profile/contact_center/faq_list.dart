import 'package:flutter/material.dart';
import 'package:packup/provider/profile/contact_center/faq_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/profile/contact_center/faq_category.dart';
import 'package:provider/provider.dart';

import '../../../model/profile/contact_center/faq_category_model.dart';
import '../../../widget/profile/contact_center/faq_section.dart';
import '../../../widget/profile/contact_center/support_card.dart';

class FaqList extends StatelessWidget {
  const FaqList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FaqProvider(),
      child: const FaqListContent(),
    );
  }
}

class FaqListContent extends StatefulWidget {
  const FaqListContent({super.key});

  @override
  State<FaqListContent> createState() => _FaqListContent();
}

class _FaqListContent extends State<FaqListContent> {

  late final _faqProvider;

  @override
  void initState() {
    super.initState();
    _faqProvider = context.read<FaqProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _faqProvider
        ..getFaqCategory()
        ..getFaqList();
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FaqProvider>();

    return Scaffold(
      appBar: CustomAppbar(
        title: '고객센터',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SupportCard(
              icon: Icons.chat_outlined,
              title: '채팅 상담',
              subtitle: '실시간 상담을 통해 빠르게 궁금증을 해결하세요.',
              onTap: () {},
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            SupportCard(
              icon: Icons.mail_outline,
              title: '이메일 문의',
              subtitle: '상세한 문의는 이메일을 남겨주시면 답변드립니다.',
              onTap: () {},
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            const Text(
              '문의 카테고리 선택',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            FaqCategory(
              categories: provider.category,
              onTapCategory: _changeFaqCategory,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            FaqSection(faqList: provider.faqList),
          ],
        ),
      ),
    );
  }

  void _changeFaqCategory(FaqCategoryModel category) {

    _faqProvider.filterByCategory(category);
  }
}

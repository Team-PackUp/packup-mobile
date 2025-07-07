import 'package:flutter/material.dart';
import 'package:packup/widget/profile/contact_center/faq_card.dart';

import '../../../widget/profile/contact_center/inquiry_wrap.dart';
import '../../../widget/profile/contact_center/support_card.dart';

class ContactCenterIndex extends StatefulWidget {
  const ContactCenterIndex({super.key});

  @override
  State<ContactCenterIndex> createState() => _ContactCenterIndexState();
}

class _ContactCenterIndexState extends State<ContactCenterIndex> {

  @override
  Widget build(BuildContext context) {

    final categories = [
      '전체',
      '예약 관련',
      '결제 관련',
      '가이드 문의',
      '계정/프로필',
      '기술 지원',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('고객센터'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SupportCard(
              icon: Icons.chat_outlined,
              title: '채팅 상담',
              subtitle: '실시간 상담을 통해 빠르게 궁금증을 해결하세요.',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            SupportCard(
              icon: Icons.mail_outline,
              title: '이메일 문의',
              subtitle: '상세한 문의는 이메일을 남겨주시면 답변드립니다.',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            SupportCard(
              icon: Icons.description_outlined,
              title: 'FAQ (자주 묻는 질문)',
              subtitle: '가장 많이 묻는 질문과 답변을 확인해보세요.',
              onTap: () {},
            ),

            const SizedBox(height: 28),
            const Text(
              '문의 카테고리 선택',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            InquiryWrap(
              categories: categories,
            ),
            const SizedBox(height: 28),
            const Text('자주 묻는 질문 (FAQ)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),

            FaqCard(question: '예약 변경은 어떻게 하나요?'),
            FaqCard(question: '결제 영수증은 어디서 확인하나요?'),
            FaqCard(question: '가이드에게 직접 문의할 수 있나요?'),
            FaqCard(question: '비밀번호를 잊어버렸어요.'),

            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  const Text('더 궁금한 점이 있으신가요?'),
                  const SizedBox(height: 4),
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
        ),
      ),
    );
  }
}

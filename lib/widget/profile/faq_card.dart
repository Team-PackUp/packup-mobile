import 'package:flutter/material.dart';
import 'package:packup/model/profile/contact_center/faq_model.dart';
import 'package:packup/widget/common/custom_empty_list.dart';

class FaqCard extends StatefulWidget {
  final List<FaqModel> faqList;

  const FaqCard({super.key, required this.faqList});

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  late List<bool> _expandedList;

  @override
  void initState() {
    super.initState();
    _expandedList = List<bool>.filled(widget.faqList.length, false);
  }

  @override
  void didUpdateWidget(covariant FaqCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.faqList.length != widget.faqList.length) {
      _expandedList = List<bool>.filled(widget.faqList.length, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    if (widget.faqList.isEmpty) {
      return const CustomEmptyList(
        message: '등록된 질문이 없습니다.',
        icon: Icons.question_mark,
      );
    }

    return Column(
      children: List.generate(widget.faqList.length, (index) {
        final faq = widget.faqList[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 1),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              side: BorderSide(color: Colors.transparent),
            ),
            collapsedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              side: BorderSide(color: Colors.transparent),
            ),
            tilePadding: EdgeInsets.symmetric(
              horizontal: screenW * 0.02,
              vertical: screenH * 0.003,
            ),
            title: Text(
              faq.question ?? '',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              _expandedList[index] ? Icons.expand_less : Icons.expand_more,
            ),
            onExpansionChanged: (v) =>
                setState(() => _expandedList[index] = v),
            children: [
              Divider(thickness: screenW * 0.001, color: Colors.grey[300]),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: screenW * 0.02,
                  vertical: screenH * 0.003,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  faq.answer ?? '',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

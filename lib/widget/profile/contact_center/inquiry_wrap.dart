import 'package:flutter/material.dart';
import 'package:packup/model/profile/contact_center/faq_category_model.dart';

class InquiryWrap extends StatefulWidget {
  final List<FaqCategoryModel> categories;
  const InquiryWrap({
    super.key,
    required this.categories,
  });

  @override
  State<InquiryWrap> createState() => _InquiryWrapState();
}

class _InquiryWrapState extends State<InquiryWrap> {
  int _selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.categories.length, (i) {
          final selected = i == _selectedIdx;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(widget.categories[i].codeName!),
              selected: selected,
              onSelected: (_) => setState(() => _selectedIdx = i),
              selectedColor: Colors.blue.shade600,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          );
        }),
      ),
    );
  }
}

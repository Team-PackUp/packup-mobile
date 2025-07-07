import 'package:flutter/material.dart';

class InquiryWrap extends StatefulWidget {
  final List categories;
  const InquiryWrap(
      {
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(widget.categories.length, (i) {
        final selected = i == _selectedIdx;
        return ChoiceChip(
          label: Text(widget.categories[i]),
          selected: selected,
          onSelected: (_) => setState(() => _selectedIdx = i),
          selectedColor: Colors.blue.shade600,
          backgroundColor: Colors.grey.shade200,
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        );
      }),
    );
  }
}
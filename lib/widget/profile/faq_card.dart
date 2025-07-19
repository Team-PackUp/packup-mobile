import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/profile/contact_center/faq_model.dart';

class FaqCard extends StatefulWidget {
  final FaqModel faq;

  const FaqCard({super.key, required this.faq});

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        tilePadding: EdgeInsets.symmetric(horizontal: screenW * 0.02, vertical: screenH * 0.003),
        title: Text(widget.faq.question ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
        onExpansionChanged: (v) => setState(() => _expanded = v),
        children: [
          Divider(thickness: screenW * 0.001, color: Colors.grey[300]),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: screenW * 0.02, vertical: screenH * 0.003),
            alignment: Alignment.centerLeft,
            child: Text(widget.faq.answer ?? '', style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

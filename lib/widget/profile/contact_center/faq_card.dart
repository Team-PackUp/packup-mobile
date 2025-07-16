import 'package:flutter/material.dart';

class FaqCard extends StatefulWidget {
  final String question;
  final String answer;
  const FaqCard({super.key, required this.question, required this.answer});

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
      margin: const EdgeInsets.symmetric(vertical: 4),
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
        title: Text(widget.question,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
        onExpansionChanged: (v) => setState(() => _expanded = v),
        children: [
          Divider(thickness: screenW * 0.001, color: Colors.grey[300]),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            padding:
            EdgeInsets.symmetric(
              horizontal: screenW * 0.02,
              vertical: screenH * 0.003,
            ),
            alignment: Alignment.centerLeft,
            child: Text(widget.answer, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

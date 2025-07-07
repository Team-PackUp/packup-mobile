import 'package:flutter/material.dart';

class FaqCard extends StatefulWidget {
  final String question;
  const FaqCard({super.key, required this.question});

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        title: Text(widget.question,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
        childrenPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onExpansionChanged: (v) => setState(() => _expanded = v),
        children: const [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '안나옵니다',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
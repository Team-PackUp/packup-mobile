import 'package:flutter/material.dart';

import '../../../../Common/util.dart';


class NoticeCard extends StatelessWidget {
  final int index;
  final String title;
  final DateTime createdAt;

  const NoticeCard({
    super.key,
    required this.index,
    required this.title,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: screenW * 0.02,
          vertical: screenH * 0.002
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 2.0,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
            horizontal: screenW * 0.05,
            vertical: screenH * 0.015
        ),
        leading: index == 0
            ? const Icon(Icons.fiber_manual_record, color: Colors.blue, size: 14)
            : null,
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          getTimeAgo(createdAt),
          style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

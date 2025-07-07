import 'package:flutter/material.dart';

import '../../../common/util.dart';

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
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.height * 0.002
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 2.0,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.015
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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/util.dart';
import '../../../model/profile/alert_center/alert_center_model.dart'; // AlertType enum 정의 위치

class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.index,
    required this.alertType,
    required this.createdAt,
    this.payload,
  });

  final int index;
  final AlertType alertType;
  final DateTime createdAt;
  final String? payload;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.02,
        vertical:  MediaQuery.of(context).size.height * 0.002,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical:   MediaQuery.of(context).size.height * 0.015,
        ),
        leading: index == 0
            ? const Icon(Icons.fiber_manual_record, color: Colors.blue, size: 14)
            : null,

        title: Text(
          alertType.message(context, item: payload),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),

        trailing: Text(
          getTimeAgo(createdAt),
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }
}

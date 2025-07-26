import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/util.dart';
import '../../model/alert_center/alert_center_model.dart';

class AlertCenterCard extends StatelessWidget {
  const AlertCenterCard({
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

    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: screenW * 0.02,
        vertical:  screenH * 0.002,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenW * 0.05,
          vertical:   screenH * 0.015,
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

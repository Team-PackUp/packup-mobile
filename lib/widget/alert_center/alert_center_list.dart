import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/alert_center/alert_center_model.dart';
import 'package:packup/widget/alert_center/alert_center_card.dart';

class AlertCenterListCard extends StatelessWidget {
  final int index;
  final AlertCenterModel alert;

  const AlertCenterListCard({
    super.key,
    required this.index,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        child: AlertCenterCard(
          index: index,
          alertType: alert.alertType,
          createdAt: alert.createdAt,
          payload: alert.payload,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../model/alert_center/alert_center_model.dart';
import 'alert_center_card.dart';
import 'package:go_router/go_router.dart';

class AlertCenterList extends StatelessWidget {
  final List<AlertCenterModel> alerts;
  final ScrollController? scrollController;

  const AlertCenterList({
    super.key,
    required this.alerts,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {

    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return ListView.separated(
      controller: scrollController,
      itemCount: alerts.length,
      padding: EdgeInsets.symmetric(
        horizontal: screenW * 0.01,
        vertical: screenH * 0.002,
      ),
      separatorBuilder: (_, __) => SizedBox(height: screenH * 0.01),
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return AlertCenterCard(
          index: index,
          alertType: alert.alertType,
          createdAt: alert.createdAt,
          payload: alert.payload,
        );
      },
    );
  }

}

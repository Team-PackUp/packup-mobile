import 'package:flutter/material.dart';
import '../../model/alert_center/alert_center_model.dart';
import 'alert_center_card.dart';
import 'package:go_router/go_router.dart';

class AlertCenterListCard extends StatelessWidget {
  final List<AlertCenterModel> alerts;
  final ScrollController? scrollController;

  const AlertCenterListCard({
    super.key,
    required this.alerts,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      itemCount: alerts.length,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01,
        vertical: MediaQuery.of(context).size.height * 0.002,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
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

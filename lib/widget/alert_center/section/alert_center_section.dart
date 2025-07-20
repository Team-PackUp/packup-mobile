import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/alert_center/alert_center_provider.dart';
import '../alert_center_list.dart';
import '../../common/custom_empty_list.dart';

class AlertCenterSection extends StatelessWidget {
  final ScrollController scrollController;

  const AlertCenterSection({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final alertCenterProvider = context.watch<AlertCenterProvider>();
    final filteredAlertList = alertCenterProvider.alertList;

    if (filteredAlertList.isEmpty && !alertCenterProvider.isLoading) {
      return const CustomEmptyList(
        message: '새 알림이 없습니다.',
        icon: Icons.notifications_none_outlined,
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: filteredAlertList.length,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01,
        vertical: MediaQuery.of(context).size.height * 0.002,
      ),
      itemBuilder: (context, index) {
        return AlertCenterListCard(
          index: index,
          alert: filteredAlertList[index],
        );
      },
    );
  }
}

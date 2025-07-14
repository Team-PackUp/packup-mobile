import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/common/custom_empty_list.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/alert_center/alert_center_provider.dart';
import '../../widget/alert_center/list_card.dart';

class AlertCenterListContent extends StatefulWidget {
  const AlertCenterListContent({super.key});

  @override
  _AlertCenterListContentState createState() => _AlertCenterListContentState();
}

class _AlertCenterListContentState extends State<AlertCenterListContent> {

  late ScrollController _scrollController;
  late AlertCenterProvider _alertCenterProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _alertCenterProvider = context.read<AlertCenterProvider>();
      await _alertCenterProvider.getAlertList(reset: true);
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      getListMore();
    }
  }

  getListMore() {
    _alertCenterProvider.getAlertList();
  }

  @override
  Widget build(BuildContext context) {
    _alertCenterProvider = context.watch<AlertCenterProvider>();
    final filteredAlertList = _alertCenterProvider.alertList;

    return Scaffold(
      appBar: CustomAppbar(title: AppLocalizations.of(context)!.notice),
      body: filteredAlertList.isEmpty
          ? CustomEmptyList(
              message: '새 알림이 없습니다.',
              icon: Icons.notifications_none_outlined,
            )
          : ListView.builder(
        controller: _scrollController,
        itemCount: filteredAlertList.length,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.height * 0.002,
        ),
        itemBuilder: (context, index) {
          final alert = filteredAlertList[index];
          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              child: ListCard(
                index: index,
                alertType: alert.alertType,
                createdAt: alert.createdAt,
                payload: alert.payload,
              ),
            ),
          );
        },
      ),
    );
  }

}

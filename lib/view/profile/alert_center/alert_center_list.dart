import 'package:flutter/material.dart';
import 'package:packup/provider/profile/alert_center/alert_center_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../../widget/profile/alert_center/list_card.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/**
 * 알림 센터를 클릭했을 때 알림에 맞는 view 페이지로 이동하는 것 실패
 */
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
      await _alertCenterProvider.getAlertList();
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

  getListMore() async {
    _alertCenterProvider.getAlertList();
  }

  @override
  Widget build(BuildContext context) {

    _alertCenterProvider = context.watch<AlertCenterProvider>();

    var filteredAlertList = _alertCenterProvider.alertList;

    return Scaffold(
      appBar: CustomAppbar(title: AppLocalizations.of(context)!.notice),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: filteredAlertList.length,
              itemBuilder: (context, index) {
                final alert = filteredAlertList[index];

                return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.01,
                      vertical: MediaQuery.of(context).size.height * 0.002,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ListCard(
                              index: index,
                              alertType: alert.alertType,
                              createdAt: alert.createdAt,
                              payload: alert.payload,
                            ),
                          ),
                        ],
                      ),
                    ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

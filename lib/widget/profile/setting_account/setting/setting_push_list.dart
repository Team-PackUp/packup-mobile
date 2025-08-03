import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_error_handler.dart';
import 'package:packup/widget/profile/setting_account/setting/setting_push_card.dart';
import 'package:provider/provider.dart';

import '../../../../common/util.dart';
import '../../../../provider/user/user_provider.dart';
import '../../../common/util_widget.dart';

class SettingPushList extends StatefulWidget {
  final bool pushFlag;
  final bool marketingFlag;

  const SettingPushList({super.key,required this.pushFlag, required  this.marketingFlag});

  @override
  State<StatefulWidget> createState() =>  _SettingPUshListState();

}

class _SettingPUshListState extends State<SettingPushList> {

  late var newPushFlag = widget.pushFlag;
  late var newMarketingFlag = widget.marketingFlag;

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: [
        SettingPushCard(
          title: "일반 푸시 수신",
          subtitle: "서비스 이용 관련 알림 수신 동의",
          value: newPushFlag,
          onChanged: (val) {
            final prevPush = newPushFlag;
            final prevMarketing = newMarketingFlag;

            setState(() => newPushFlag = val);

            updateSettingPushWithRollback(
              oldPush: prevPush,
              oldMarketing: prevMarketing,
              successMessage: "푸시 수신 설정이 변경되었습니다.",
            );
          },
        ),

        const Divider(),

        SettingPushCard(
          title: "마케팅 푸시 수신 동의",
          subtitle: "이벤트, 할인 등 마케팅 정보 수신",
          value: newMarketingFlag,
          onChanged: (val) {
            final prevPush = newPushFlag;
            final prevMarketing = newMarketingFlag;

            setState(() => newMarketingFlag = val);

            updateSettingPushWithRollback(
              oldPush: prevPush,
              oldMarketing: prevMarketing,
              successMessage: "마케팅 수신 설정이 변경되었습니다.",
            );
          },
        ),
      ],
    );
  }

  Future<void> updateSettingPushWithRollback({
    required bool oldPush,
    required bool oldMarketing,
    required String successMessage,
  }) async {
    try {
      await context.read<UserProvider>().updateSettingPush(newPushFlag, newMarketingFlag);

      CustomSnackBar.showResult(context, successMessage);

    } catch (e) {
      setState(() {
        newPushFlag = oldPush;
        newMarketingFlag = oldMarketing;
      });
      CustomErrorHandler.run(context, e);
    }
  }
}
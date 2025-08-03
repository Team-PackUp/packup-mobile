import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          onChanged: (val) async {
            final prevValue = newPushFlag;

            setState(() => newPushFlag= val);

            try {
              if(!await updateSettingPush()) {
                throw Exception("푸시 수신 설정 변경에 실패했습니다.");
              }
              CustomSnackBar.showResult(context, "푸시 수신 설정 변경 하였습니다.");

            } catch (e) {
              setState(() => newPushFlag = prevValue);
              CustomSnackBar.showError(context, e.toString());
            }
          },
        ),

        const Divider(),
        SettingPushCard(
          title: "마케팅 푸시 수신 동의",
          subtitle: "이벤트, 할인 등 마케팅 정보 수신",
          value: newMarketingFlag,
          onChanged: (val) async {
            final prevValue = newMarketingFlag;

            setState(() => newMarketingFlag = val);

            try {
              if(!await updateSettingPush()) {
                throw Exception("마케팅 수신 설정 변경 하였습니다.");
              }

              CustomSnackBar.showResult(context, "마케팅 수신 설정 변경 하였습니다.");

            } catch (e) {
              setState(() => newMarketingFlag = prevValue);
              CustomSnackBar.showError(context, e.toString());
            }
          },
        ),
        // SettingPushCard(
        //   title: "광고 푸시 수신 동의",
        //   subtitle: "신규 상품, 프로모션 등 광고 정보 수신",
        //   value: ad,
        //   onChanged: (val) => setState(() => ad = val),
        // ),
      ],
    );
  }

  Future<bool> updateSettingPush() async {

    return await context.read<UserProvider>().updateSettingPush(newPushFlag, newMarketingFlag);
  }

}
import 'package:flutter/material.dart';
import 'package:packup/model/user/user_withdraw_log/user_withdraw_log_model.dart';
import 'package:packup/provider/user/user_withdraw_log_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/profile/setting_account/setting/section/setting_withdraw_confirm_section.dart';
import 'package:provider/provider.dart';

import '../../../../widget/common/alert_bell.dart';
import '../../../../widget/profile/setting_account/setting/section/setting_withdraw_section.dart';

class SettingWithdrawConfirm extends StatelessWidget {
  final UserWithDrawLogModel userWithDrawLogModel;
  const SettingWithdrawConfirm({super.key, required this.userWithDrawLogModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
          return UserWithDrawLogProvider();
      },
      child: SettingWithdrawConfirmContent(userWithDrawLogModel: userWithDrawLogModel,),
    );
  }


}

class SettingWithdrawConfirmContent extends StatefulWidget {
  final UserWithDrawLogModel userWithDrawLogModel;
  const SettingWithdrawConfirmContent({super.key, required this.userWithDrawLogModel});

  @override
  State<SettingWithdrawConfirmContent> createState() => _SettingWithdrawConfirmState();
}

class _SettingWithdrawConfirmState extends State<SettingWithdrawConfirmContent> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          title: '탈퇴하기',
          alert: AlertBell(),
        ),
      body: SettingWithdrawConfirmSection(UserWithDrawLogModel: widget.userWithDrawLogModel,)
    );
  }
}
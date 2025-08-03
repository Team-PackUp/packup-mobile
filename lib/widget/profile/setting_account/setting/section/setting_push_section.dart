import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/widget/profile/setting_account/setting/setting_push_list.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../../../common/util.dart';
import '../../../../common/util_widget.dart';
import '../setting_push_card.dart';

class SettingPushSection extends StatefulWidget {
  const SettingPushSection({super.key});

  @override
  State<SettingPushSection> createState() => _SettingPushSectionState();

}

class _SettingPushSectionState extends State<SettingPushSection> {
  late bool pushFlag;
  late bool marketingFlag;

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().userModel!;
    pushFlag = stringToBoolean(user.pushFlag!);
    marketingFlag = stringToBoolean(user.marketingFlag!);

    return SettingPushList(pushFlag: pushFlag, marketingFlag: marketingFlag);
  }
}

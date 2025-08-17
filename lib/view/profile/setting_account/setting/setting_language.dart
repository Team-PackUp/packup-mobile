import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/profile/setting_account/setting/section/setting_language_section.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/widget/common/custom_error_handler.dart';
import 'package:packup/widget/common/util_widget.dart';

import '../../../../model/user/profile/user_profile_model.dart';

class SettingLanguage extends StatefulWidget {
  const SettingLanguage({
    super.key,
    this.initialLanguageCode,
    this.onSaved,
  });

  final String? initialLanguageCode;
  final ValueChanged<String>? onSaved;

  @override
  State<SettingLanguage> createState() => _SettingLanguageState();
}

class _SettingLanguageState extends State<SettingLanguage> {

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppbar(
        title: "국가/지역 설정",
      ),
      body: SettingLanguageSection()
    );
  }
}

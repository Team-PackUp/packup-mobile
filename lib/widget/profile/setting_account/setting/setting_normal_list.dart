import 'package:flutter/material.dart';
import 'package:packup/widget/profile/setting_account/setting/setting_push_list.dart';
import 'package:provider/provider.dart';

import '../../../../Common/util.dart';
import '../../../../provider/user/user_provider.dart';
import 'normal_setting_card.dart';

class SettingNormalList extends StatelessWidget {
  const SettingNormalList({
    super.key,
    required this.onTapNation,
    required this.onTapLanguage,
    this.textStyle,
  });

  final VoidCallback onTapNation;
  final VoidCallback onTapLanguage;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final titleStyle = textStyle ?? TextStyle(fontSize: screenW * 0.04);

    String langLabelFromCode(String? code) {
      switch (code) {
        case '030101': return '한국어';
        case '030102': return 'English';
        case '030103': return '日本語';
        case '030104': return '中文';
        default:   return code ?? '한국어';
      }
    }

    String countryLabelFromCode(String? code) {
      switch (code) {
        case '030001': return '대한민국';
        case '030002': return '미국';
        case '030003': return '일본';
        case '030004': return '중국';
        default:   return code ?? '대한민국';
      }
    }

    final user = context.watch<UserProvider>().userModel!;

    final currentLangLabel    = langLabelFromCode(user.userLanguage);
    final currentNationLabel = countryLabelFromCode(user.userNation);

    var pushFlag = stringToBoolean(user.pushFlag!);
    var marketingFlag = stringToBoolean(user.marketingFlag!);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.04, vertical: screenH * 0.01),
          child: SettingPushList(
            pushFlag: pushFlag,
            marketingFlag: marketingFlag,
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.04, vertical: screenH * 0.01),
          child: NormalSettingCard(
            title: '국가/지역',
            valueText: currentNationLabel,
            onTap: onTapNation,
            titleStyle: titleStyle,
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.04, vertical: screenH * 0.01),
          child: NormalSettingCard(
            title: '언어 설정',
            valueText: currentLangLabel,
            onTap: onTapLanguage,
            titleStyle: titleStyle,
          ),
        ),
      ],
    );
  }
}

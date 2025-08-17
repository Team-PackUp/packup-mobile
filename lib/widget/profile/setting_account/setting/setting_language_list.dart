import 'package:flutter/cupertino.dart';
import 'package:packup/widget/profile/setting_account/setting/setting_language_card.dart';

class SettingLanguageList extends StatelessWidget {
  const SettingLanguageList({
    super.key,
    required this.languages,
    required this.groupValue,
    required this.onChanged,
    this.activeColor,
  });

  final List<Map<String, String>> languages;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(languages.length, (i) {
        final lang = languages[i];
        return Padding(
          padding: EdgeInsets.only(bottom: i == languages.length - 1 ? 0 : 8),
          child: LanguageCard(
            code: lang['code']!,
            label: lang['label']!,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        );
      }),
    );
  }
}

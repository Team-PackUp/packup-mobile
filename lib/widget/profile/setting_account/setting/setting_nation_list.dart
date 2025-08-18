import 'package:flutter/cupertino.dart';
import 'package:packup/widget/profile/setting_account/setting/setting_nation_card.dart';

class SettingNationList extends StatelessWidget {
  const SettingNationList({
    super.key,
    required this.items,
    required this.selectedCode,
    required this.onChanged,
    this.itemSpacing = 8.0,
  });

  final List<Map<String, String>> items;
  final String selectedCode;
  final ValueChanged<String> onChanged;
  final double itemSpacing;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: itemSpacing),
      itemBuilder: (context, i) {
        final e = items[i];
        final code = e['code']!;
        final label = e['label']!;
        return SettingNationCard(
          code: code,
          label: label,
          selected: selectedCode == code,
          onTap: () => onChanged(code),
        );
      },
    );
  }
}
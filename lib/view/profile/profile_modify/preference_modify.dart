import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/common/util_widget.dart';
import 'package:packup/widget/profile/profile_modify/preference_modify_section.dart';

class PreferenceModify extends StatefulWidget {
  final List<String> alreadyPreference;

  const PreferenceModify({super.key, required this.alreadyPreference});

  @override
  State<PreferenceModify> createState() => _PreferenceModifyState();
}

class _PreferenceModifyState extends State<PreferenceModify> {

  Set<String> selected = {};

  @override
  void initState() {
    super.initState();
    selected = Set<String>.from(widget.alreadyPreference);
  }

  void toggleSelect(String category) {
    setState(() {
      if (selected.contains(category)) {
        selected.remove(category);
      } else {
        selected.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: '관심사 수정'),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PreferenceModifySection(
                selected: selected,
                toggleSelect: toggleSelect,
              ),
            ),

            CustomButton.textButton(
              context: context,
              onPressed: () {
                context.pop(selected.toList());
              },
              backgroundColor: PRIMARY_COLOR,
              label: '선택 완료',
            )
          ],
        ),
      ),
    );
  }

}

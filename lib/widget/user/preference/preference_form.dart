// preference_form.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/user/user_preference_provider.dart';

class PreferenceForm extends StatelessWidget {
  const PreferenceForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserPreferenceProvider>(context);
    final options = ['문화', '역사', '자연', '음식', '체험'];

    return Column(
      children: [
        Wrap(
          spacing: 10,
          children: options.map((e) => ChoiceChip(
            label: Text(e),
            selected: provider.selected.contains(e),
            onSelected: (_) => provider.togglePreference(e),
          )).toList(),
        ),
        ElevatedButton(
          onPressed: () async {
            await provider.submitPreferences();
            // TODO: 이동 처리 (e.g., Navigator.pop() 또는 다음 화면)
          },
          child: const Text("선택 완료"),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class PreferenceForm extends StatefulWidget {
  const PreferenceForm({super.key});
  @override
  State<PreferenceForm> createState() => _PreferenceFormState();
}

class _PreferenceFormState extends State<PreferenceForm> {
  final selected = <String>{};

  @override
  Widget build(BuildContext context) {
    final options = ['문화', '역사', '자연', '음식', '체험'];

    return Column(
      children: [
        Wrap(
          spacing: 10,
          children: options.map((e) => ChoiceChip(
            label: Text(e),
            selected: selected.contains(e),
            onSelected: (val) {
              setState(() {
                val ? selected.add(e) : selected.remove(e);
              });
            },
          )).toList(),
        ),
        ElevatedButton(
          onPressed: () {
            // 저장 후 이동
          },
          child: const Text("선택 완료"),
        ),
      ],
    );
  }
}

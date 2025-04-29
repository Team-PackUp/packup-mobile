// preference_view.dart
import 'package:flutter/material.dart';
import 'package:packup/widget/user/preference/preference_form.dart';

class Preference extends StatelessWidget {
  const Preference({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("선호도 선택")),
      body: const PreferenceForm(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/user/user_preference_provider.dart';
import 'package:packup/widget/user/preference/preference_form.dart';

class Preference extends StatelessWidget {
  const Preference({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserPreferenceProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text("선호도 선택")),
        body: const PreferenceForm(),
      ),
    );
  }
}

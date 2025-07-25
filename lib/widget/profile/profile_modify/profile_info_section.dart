import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/user/user_provider.dart';
import '../../common/custom_show_picker.dart';

class ProfileInfoSection extends StatefulWidget {
  const ProfileInfoSection({super.key});

  @override
  State<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends State<ProfileInfoSection> {
  late TextEditingController nameController;
  String selectedLanguage = '한국어'; // 초기값

  final List<String> languageOptions = ['한국어', 'English', '日本語'];

  @override
  void initState() {
    super.initState();
    final nickname = context.read<UserProvider>().userModel?.nickname ?? '';
    nameController = TextEditingController(text: nickname);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: '이름',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: h * 0.02),
        GestureDetector(
          onTap: () {
            final initialIndex = languageOptions.indexOf(selectedLanguage);
            showCustomPicker(
              context,
              selectedIndex: initialIndex >= 0 ? initialIndex : 0,
              options: languageOptions,
              onSelected: (index) {
                setState(() {
                  selectedLanguage = languageOptions[index];
                });
              },
            );
          },
          child: AbsorbPointer(
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: '언어',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              controller: TextEditingController(text: selectedLanguage),
            ),
          ),
        ),
      ],
    );
  }
}

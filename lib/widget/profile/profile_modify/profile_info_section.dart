import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/user/user_provider.dart';
import '../../common/custom_show_picker.dart';

class ProfileInfoSection extends StatefulWidget {
  final void Function(String nickname, String language) detailInfoChange;

  const ProfileInfoSection({super.key, required this.detailInfoChange});

  @override
  State<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends State<ProfileInfoSection> {
  late TextEditingController nickNameController;
  late TextEditingController languageController;

  String selectedLanguage = '한국어'; // 초기값

  final List<String> languageOptions = ['한국어', 'English', '日本語'];

  @override
  void initState() {
    super.initState();

    final nickname = context.read<UserProvider>().userModel?.nickname ?? '';
    nickNameController = TextEditingController(text: nickname);
    languageController = TextEditingController(text: selectedLanguage);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emitChange();
    });
  }

  void _emitChange() {
    widget.detailInfoChange(nickNameController.text, selectedLanguage);
  }

  @override
  void dispose() {
    nickNameController.dispose();
    languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nickNameController,
          decoration: const InputDecoration(
            labelText: '이름',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _emitChange(),
        ),
        SizedBox(height: screenH * 0.02),
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
                  languageController.text = selectedLanguage;
                });
                _emitChange();
              },
            );
          },
          child: AbsorbPointer(
            child: TextFormField(
              readOnly: true,
              controller: languageController,
              decoration: const InputDecoration(
                labelText: '언어',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

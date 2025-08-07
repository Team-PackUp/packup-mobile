import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/common/code_mapping_model.dart';
import '../../../provider/user/user_provider.dart';
import '../../common/custom_show_picker.dart';

class ProfileInfoSection extends StatefulWidget {
  final void Function(String nickname, String languageCode, String age, String genderCode) detailInfoChange;

  const ProfileInfoSection({super.key, required this.detailInfoChange});

  @override
  State<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends State<ProfileInfoSection> {
  late TextEditingController nickNameController;
  late TextEditingController ageController;
  late TextEditingController genderController;
  late TextEditingController languageController;

  String selectedGenderCode = '';
  String selectedLanguageCode = '';

  final List<CodeMappingModel> genderOptions = [
    CodeMappingModel(code: '020001', label: '남성'),
    CodeMappingModel(code: '020002', label: '여성'),
    CodeMappingModel(code: '020003', label: '기타'),
  ];

  final List<CodeMappingModel> languageOptions = [
    CodeMappingModel(code: '030101', label: '한국어'),
    CodeMappingModel(code: '030102', label: 'English'),
    CodeMappingModel(code: '030103', label: '中國語'),
    CodeMappingModel(code: '030104', label: '日本語'),
  ];

  @override
  void initState() {
    super.initState();

    final user = context.read<UserProvider>().userModel!;
    nickNameController = TextEditingController(text: user.nickname ?? '');
    ageController = TextEditingController(text: user.userAge ?? '');

    final initGender = genderOptions.firstWhere(
          (e) => e.code == user.userGender,
      orElse: () => genderOptions.first,
    );

    final initLanguage = languageOptions.firstWhere(
          (e) => e.code == user.userLanguage,
      orElse: () => languageOptions.first,
    );

    genderController = TextEditingController(text: initGender.label);
    languageController = TextEditingController(text: initLanguage.label);

    selectedGenderCode = initGender.code;
    selectedLanguageCode = initLanguage.code;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emitChange();
    });
  }

  void _emitChange() {
    widget.detailInfoChange(
      nickNameController.text,
      selectedLanguageCode,
      ageController.text,
      selectedGenderCode,
    );
  }

  @override
  void dispose() {
    nickNameController.dispose();
    ageController.dispose();
    genderController.dispose();
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
        TextField(
          keyboardType: TextInputType.number,
          controller: ageController,
          decoration: const InputDecoration(
            labelText: '나이',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _emitChange(),
        ),
        SizedBox(height: screenH * 0.02),
        GestureDetector(
          onTap: () {
            final initialIndex = genderOptions.indexWhere((e) => e.code == selectedGenderCode);
            showCustomPicker(
              context,
              selectedIndex: initialIndex >= 0 ? initialIndex : 0,
              options: genderOptions.map((e) => e.label).toList(),
              onSelected: (index) {
                setState(() {
                  selectedGenderCode = genderOptions[index].code;
                  genderController.text = genderOptions[index].label;
                });
                _emitChange();
              },
            );
          },
          child: AbsorbPointer(
            child: TextFormField(
              readOnly: true,
              controller: genderController,
              decoration: const InputDecoration(
                labelText: '성별',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
        ),
        SizedBox(height: screenH * 0.02),
        GestureDetector(
          onTap: () {
            final initialIndex = languageOptions.indexWhere((e) => e.code == selectedLanguageCode);
            showCustomPicker(
              context,
              selectedIndex: initialIndex >= 0 ? initialIndex : 0,
              options: languageOptions.map((e) => e.label).toList(),
              onSelected: (index) {
                setState(() {
                  selectedLanguageCode = languageOptions[index].code;
                  languageController.text = languageOptions[index].label;
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


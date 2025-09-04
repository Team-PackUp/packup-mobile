import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Common/util.dart';
import '../../../../model/common/code_mapping_model.dart';
import '../../../../provider/user/user_provider.dart';
import '../../../common/custom_birth_input.dart';
import '../../../common/custom_show_picker.dart';

class ProfileInfoSection extends StatefulWidget {
  final void Function(String nickname, String languageCode, String birth, String genderCode) detailInfoChange;

  const ProfileInfoSection({super.key, required this.detailInfoChange});

  @override
  State<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends State<ProfileInfoSection> {
  late TextEditingController nickNameController;
  late TextEditingController genderController;

  DateTime? birth;

  String selectedGenderCode = '';
  String selectedLanguageCode = '';

  final FocusNode _noopFocus = FocusNode(debugLabel: 'noop');

  final List<CodeMappingModel> genderOptions = [
    CodeMappingModel(code: '020001', label: '남성'),
    CodeMappingModel(code: '020002', label: '여성'),
    CodeMappingModel(code: '020003', label: '기타'),
  ];

  @override
  void initState() {
    super.initState();

    final user = context.read<UserProvider>().userModel!;
    nickNameController = TextEditingController(text: user.nickname ?? '');

    if (user.userBirth.isNotEmpty) {
      birth = DateTime.tryParse(user.userBirth);
    }

    final initGender = genderOptions.firstWhere(
          (e) => e.code == user.userGender,
      orElse: () => genderOptions.first,
    );

    genderController = TextEditingController(text: initGender.label);

    selectedGenderCode = initGender.code;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emitChange();
    });
  }

  void _emitChange() {
    widget.detailInfoChange(
      nickNameController.text,
      selectedLanguageCode,
      birth == null ? "" : convertToYmd(birth!),
      selectedGenderCode,
    );
  }

  @override
  void dispose() {
    nickNameController.dispose();
    genderController.dispose();
    _noopFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Focus(
            focusNode: _noopFocus,
            skipTraversal: true,
            descendantsAreFocusable: false,
            child: const SizedBox.shrink(),
          ),
          Text(
            "기본 정보",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 18),
          TextField(
            controller: nickNameController,
            decoration: const InputDecoration(
              labelText: '닉네임',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _emitChange(),
          ),
          SizedBox(height: 18),

          const Text("생년월일"),
          CustomBirthInput(
            initialDate: birth,
            onDateChanged: (val) {
              setState(() {
                birth = val;
              });
              _emitChange();
            },
          ),

          SizedBox(height: 32),
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
              if (!mounted) return;
              FocusScope.of(context).requestFocus(_noopFocus);

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
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/common/custom_birth_input.dart';
import 'package:provider/provider.dart';

import 'package:packup/const/color.dart';
import 'package:packup/model/user/register_detail/register_detail_model.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/service/user/register_detail_service.dart';
import 'package:packup/provider/common/code_mapping_model.dart';

import '../../../Common/util.dart';

class RegisterDetail extends StatefulWidget {
  const RegisterDetail({super.key});

  @override
  State<RegisterDetail> createState() => _RegisterDetailState();
}

class _RegisterDetailState extends State<RegisterDetail> {
  String? _selectedGenderDisplay;
  String? _selectedNationDisplay;
  String? _selectedLanguageDisplay;
  String? _birth;

  final genderOptions = {
    '남성': '남성',
    '여성': '여성',
    '기타': '성별-기타',
  };

  final nationOptions = {
    '대한민국': '대한민국',
    '미국': '미국',
    '일본': '일본',
    '중국': '중국',
    '기타': '국가-기타',
  };

  final List<CodeMappingModel> languageOptions = [
    CodeMappingModel(code: '030101', label: '한국어'),
    CodeMappingModel(code: '030102', label: 'English'),
    CodeMappingModel(code: '030103', label: '中國語'),
    CodeMappingModel(code: '030104', label: '日本語'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus(); // 터치 시 키보드 내림
          },
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '자기소개를 해주세요',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '성별, 나이, 국적, 언어를 입력해주세요.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // 성별
                const Text('성별', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: genderOptions.entries.map((entry) {
                    final label = entry.key;
                    final isSelected = _selectedGenderDisplay == label;

                    return ChoiceChip(
                      label: Text(label),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _selectedGenderDisplay = label);
                      },
                      selectedColor: SECONDARY_COLOR.withOpacity(0.2),
                      checkmarkColor: SECONDARY_COLOR,
                      labelStyle: TextStyle(
                        color: isSelected ? SECONDARY_COLOR : Colors.black,
                      ),
                      backgroundColor: Colors.grey.shade100,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // 나이
                const Text('나이', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                // TextField(
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //     hintText: '예: 25',
                //     border: const OutlineInputBorder(),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: SECONDARY_COLOR, width: 2),
                //     ),
                //   ),
                //   onChanged: (val) => _age = val,
                // ),
                CustomBirthInput(
                  onDateChanged: (val) => _birth = convertToYmd(val!),
                ),
                const SizedBox(height: 24),

                // 국적
                const Text('국적', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedNationDisplay,
                  items: nationOptions.keys.map((label) {
                    return DropdownMenuItem(value: label, child: Text(label));
                  }).toList(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SECONDARY_COLOR, width: 2),
                    ),
                  ),
                  hint: const Text('국가를 선택하세요'),
                  onChanged: (val) => setState(() => _selectedNationDisplay = val),
                ),
                const SizedBox(height: 24),

                // 언어
                const Text('언어', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedLanguageDisplay,
                  items: languageOptions.map((lang) {
                    return DropdownMenuItem(
                      value: lang.label,
                      child: Text(lang.label),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SECONDARY_COLOR, width: 2),
                    ),
                  ),
                  hint: const Text('언어를 선택하세요'),
                  onChanged: (val) => setState(() => _selectedLanguageDisplay = val),
                ),
                const SizedBox(height: 48),

                // 다음 버튼
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_selectedGenderDisplay == null ||
                          _selectedNationDisplay == null ||
                          _selectedLanguageDisplay == null ||
                          _birth == null ||
                          _birth!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('모든 정보를 입력해주세요.')),
                        );
                        return;
                      }
                      final selectedLanguageCode = languageOptions
                          .firstWhere((e) => e.label == _selectedLanguageDisplay!)
                          .code;

                      final model = RegisterDetailModel(
                        userGender: _selectedGenderDisplay!,
                        userBirth: _birth!,
                        userNation: _selectedNationDisplay!,
                        userLanguage: selectedLanguageCode,
                      );

                      try {
                        final service = RegisterDetailService();
                        await service.submitUserDetail(model);

                        // 유저 정보 동기화
                        await context.read<UserProvider>().getMyInfo();

                        // 다음 페이지 이동
                        context.go('/preference');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('저장 실패: ${e.toString()}')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SECONDARY_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('다음'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/widget/common/custom_error_handler.dart';
import 'package:packup/widget/common/util_widget.dart';
import 'package:packup/widget/profile/setting_account/setting/setting_language_list.dart';

import '../../../../../Const/color.dart';

class SettingLanguageSection extends StatefulWidget {
  const SettingLanguageSection({
    super.key,
    this.onSaved,
  });

  final ValueChanged<String>? onSaved;

  @override
  State<SettingLanguageSection> createState() => _SettingLanguageSectionState();
}

class _SettingLanguageSectionState extends State<SettingLanguageSection> {
  static const List<Map<String, String>> _languages = [
    {'code': '030101', 'label': '한국어'},
    {'code': '030102', 'label': 'English'},
    {'code': '030103', 'label': '日本語'},
    {'code': '030104', 'label': '中文'},
  ];

  late String _selectedCode;
  late String _initialCode;
  bool _syncedOnce = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().userModel;
    _initialCode = user?.userLanguage ?? '030101';
    _selectedCode = _initialCode;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_syncedOnce) {
      final user = context.read<UserProvider>().userModel;
      final lang = user?.userLanguage;
      if (lang != null && lang != _initialCode) {
        _syncedOnce = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _initialCode = lang;
            _selectedCode = lang;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('언어 선택',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),

              SettingLanguageList(
                languages: _languages,
                groupValue: _selectedCode,
                activeColor: cs.primary,
                onChanged: (code) => setState(() => _selectedCode = code),
              ),

              const Spacer(),

              SizedBox(
                height: 48,
                child: CustomButton.textButton(
                context: context,
                onPressed: () {
                  _selectedCode == _initialCode ? null : updateLanguage();
                },
                label: '저장하기',
                backgroundColor: PRIMARY_COLOR,
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateLanguage() async {
    try {
      await context
          .read<UserProvider>()
          .updateSettingLanguage(_selectedCode);

      setState(() {
        _initialCode = _selectedCode;
      });
      widget.onSaved?.call(_selectedCode);

      CustomSnackBar.showResult(context, '언어가 변경되었습니다.');
    } catch (e) {
      CustomErrorHandler.run(context, e);
    }
  }
}

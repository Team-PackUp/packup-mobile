import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/widget/common/custom_error_handler.dart';
import 'package:packup/widget/common/util_widget.dart';
import 'package:packup/widget/profile/setting_account/setting/setting_language_list.dart';

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
  bool _syncedOnce = false; // userModel이 늦게 들어올 때 1회 동기화용
  bool _submitting = false;

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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: (_selectedCode == _initialCode || _submitting)
                      ? null
                      : () async {
                    setState(() => _submitting = true);
                    try {
                      await context
                          .read<UserProvider>()
                          .updateSettingLanguage(_selectedCode);

                      if (!mounted) return;
                      CustomSnackBar.showResult(context, '국가/지역이 변경되었습니다.');

                      setState(() => _initialCode = _selectedCode);

                      widget.onSaved?.call(_selectedCode);
                    } catch (e) {
                      if (!mounted) return;
                      CustomErrorHandler.run(context, e);
                    } finally {
                      if (!mounted) return;
                      setState(() => _submitting = false);
                    }
                  },
                  child: const Text('적용',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

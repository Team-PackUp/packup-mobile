import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/widget/profile/setting_account/setting/setting_nation_list.dart';
import 'package:packup/widget/search/search.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/widget/common/custom_error_handler.dart';
import 'package:packup/widget/common/util_widget.dart';

class SettingNationSection extends StatefulWidget {
  const SettingNationSection({
    super.key,
    this.onSaved,
  });

  final ValueChanged<String>? onSaved;

  @override
  State<SettingNationSection> createState() => _SettingNationSectionState();
}

class _SettingNationSectionState extends State<SettingNationSection> {
  static const List<Map<String, String>> _countries = [
    {'code': '030001', 'label': '대한민국'},
    {'code': '030002', 'label': '미국'},
    {'code': '030003', 'label': '일본'},
    {'code': '030004', 'label': '중국'},
  ];

  late String _selectedCode;
  late String _initialCode;
  String _query = '';
  bool _syncedOnce = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().userModel;
    _initialCode = user?.userNation ?? '030001';
    _selectedCode = _initialCode;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_syncedOnce) {
      final user = context.read<UserProvider>().userModel;
      final nation = user?.userNation;
      if (nation != null && nation != _initialCode) {
        _syncedOnce = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _initialCode = nation;
            _selectedCode = nation;
          });
        });
      }
    }
  }

  List<Map<String, String>> get _filtered {
    if (_query.trim().isEmpty) return _countries;
    final q = _query.trim().toLowerCase();
    return _countries.where((c) {
      final label = c['label']!.toLowerCase();
      final code  = c['code']!.toLowerCase();
      return label.contains(q) || code.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final user = context.watch<UserProvider>().userModel;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 검색창
              CustomSearch(
                mode: SearchMode.input,
                hint: '국가 또는 지역 검색…',
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 12),

              // 리스트
              Expanded(
                child: SettingNationList(
                  items: _filtered,
                  selectedCode: _selectedCode,
                  onChanged: (code) => setState(() => _selectedCode = code),
                ),
              ),

              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: CustomButton.textButton(
                  context: context,
                  onPressed: () {
                    _selectedCode == _initialCode ? null : updateNation();
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

  Future<void> updateNation() async {
    try {
      await context
          .read<UserProvider>()
          .updateSettingNation(_selectedCode);

      setState(() {
        _initialCode = _selectedCode;
      });
      widget.onSaved?.call(_selectedCode);

      CustomSnackBar.showResult(context, '국가/지역이 변경되었습니다.');
    } catch (e) {
      CustomErrorHandler.run(context, e);
    }
  }
}

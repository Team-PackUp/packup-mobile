import 'package:flutter/material.dart';
import 'package:packup/widget/profile/setting_account/setting/setting_nation_list.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/widget/common/custom_error_handler.dart';
import 'package:packup/widget/common/util_widget.dart';

class SettingNationSection extends StatefulWidget {
  const SettingNationSection({
    super.key,
    required this.initialCountryCode,
    this.onSaved,
  });

  final String initialCountryCode;     // 예: '030001'
  final ValueChanged<String>? onSaved; // 저장 성공 시 알림용

  @override
  State<SettingNationSection> createState() => _SettingNationSectionState();
}

class _SettingNationSectionState extends State<SettingNationSection> {
  static const List<Map<String, String>> _countries = [
    {'code': '030001', 'label': '대한민국'},
    {'code': '030002', 'label': '미국'},
    {'code': '030003', 'label': '일본'},
    {'code': '030004', 'label': '중국'},
    {'code': '030005', 'label': '영국'},
    {'code': '030006', 'label': '프랑스'},
    {'code': '030007', 'label': '독일'},
    {'code': '030008', 'label': '호주'},
    {'code': '030009', 'label': '캐나다'},
    {'code': '030010', 'label': '인도'},
    {'code': '030011', 'label': '브라질'},
    {'code': '030012', 'label': '멕시코'},
    {'code': '030013', 'label': '남아프리카 공화국'},
    {'code': '030014', 'label': '사우디아라비아'},
    {'code': '030015', 'label': '러시아'},
    {'code': '030016', 'label': '스페인'},
    {'code': '030017', 'label': '스웨덴'},
    {'code': '030018', 'label': '스위스'},
    {'code': '030019', 'label': '네덜란드'},
  ];

  late String _selectedCode;
  late String _initialCode;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _initialCode = widget.initialCountryCode;
    _selectedCode = _initialCode;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 검색창
        TextField(
          decoration: InputDecoration(
            hintText: '국가 또는 지역 검색…',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 12),

        // 리스트 섹션
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
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _selectedCode == _initialCode
                ? null
                : () async {
              try {
                // await context.read<UserProvider>().updateSettingCountry(_selectedCode);

                CustomSnackBar.showResult(context, '국가/지역이 변경되었습니다.');
                widget.onSaved?.call(_selectedCode);
                if (!mounted) return;
                Navigator.pop(context);
              } catch (e) {
                CustomErrorHandler.run(context, e);
              }
            },
            child: const Text('적용', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/user/user_withdraw_log/user_withdraw_log_model.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/util_widget.dart';

class SettingWithdrawSection extends StatefulWidget {
  const SettingWithdrawSection({super.key});

  @override
  State<SettingWithdrawSection> createState() => _SettingWithdrawSectionState();
}

class _SettingWithdrawSectionState extends State<SettingWithdrawSection> {
  String? _selectedReason;
  final List<String> _reasons = [
    '하늘성은 존재한다.',
    '내가 오뎅이 되는 거야',
    '용기 있는 자는 두려움을 적에게 던진다',
    '실패는 길지 않다.',
    '기타 치는 개미',
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().userModel!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${user.nickname}님, 탈퇴하시겠어요?',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            '탈퇴 사유를 선택해주세요',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            hint: const Text('사유 선택'),
            value: _selectedReason,
            onChanged: (value) {
              setState(() {
                _selectedReason = value;
              });
            },
            items: _reasons.map((reason) {
              return DropdownMenuItem<String>(
                value: reason,
                child: Text(reason),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: CustomButton.textButton(
                      context: context,
                      onPressed: () => context.go('/'),
                      backgroundColor: Colors.green,
                      label: '여행하기'
                  )
              ),
              Expanded(
                child: CustomButton.textButton(
                    context: context,
                    onPressed: _withDrawProcess,
                    backgroundColor: Colors.red,
                    label: '탈퇴하기'
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  _withDrawProcess() {
    if (_selectedReason == null) {
      CustomSnackBar.showResult(context, '탈퇴 사유를 입력해주세요');
      return;
    }

    final userWithdrawLog = UserWithDrawLogModel(
        reason: _selectedReason!, codeName: 'WITHDRAW');

    context.push("/profile/withdraw-confirm", extra: userWithdrawLog);
    print("real withdraw");
  }

}

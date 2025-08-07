import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/user/user_withdraw_log/user_withdraw_log_model.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/user/user_provider.dart';
import '../../../../common/custom_error_handler.dart';
import '../../../../common/util_widget.dart';

class SettingWithdrawConfirmSection extends StatefulWidget {
  final UserWithDrawLogModel;
  const SettingWithdrawConfirmSection({super.key, required this.UserWithDrawLogModel});

  @override
  State<SettingWithdrawConfirmSection> createState() => _SettingWithdrawConfirmSectionState();
}

class _SettingWithdrawConfirmSectionState extends State<SettingWithdrawConfirmSection> {

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().userModel!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${user.nickname}님, 기어코... 탈퇴하시겠어요?',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            '탈퇴 시 유의사항',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('• 작성한 글 및 채팅 기록이 삭제됩니다 (상대방은 확인 가능)'),
          const Text('• 탈퇴 후 7일간 재가입이 제한됩니다'),
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
                    onPressed: () {
                      _withDrawProcess(model: widget.UserWithDrawLogModel);
                    },
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

  Future<void> _withDrawProcess({
    required UserWithDrawLogModel model,
  }) async {
    try {
      CustomSnackBar.showResult(context, "회원 탈퇴 되었습니다.");

      context.read<UserProvider>()
        ..userWithDraw(model)
        ..logout(context);

    } catch (e) {
      CustomErrorHandler.run(context, e);
    }
  }
}

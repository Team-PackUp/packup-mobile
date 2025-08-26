import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/user/user_provider.dart';
import '../../../../common/util_widget.dart';

class EtcSection extends StatelessWidget {
  final double screenW;

  const EtcSection({super.key, required this.screenW});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomButton.textIconButton(
          context: context,
          icon: Icons.logout,
          label: '로그아웃',
          onPressed: () {
            context.read<UserProvider>().logout(context);
            CustomSnackBar.showResult(context, "로그아웃 되었습니다.");
          },
        ),
        CustomButton.textIconButton(
          context: context,
          icon: Icons.delete_forever,
          label: '탈퇴하기',
          onPressed: () => context.push('/profile/withdraw'),
        ),
      ],
    );
  }
}

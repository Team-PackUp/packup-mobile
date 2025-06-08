import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/widget/login/social_login_btn.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<UserProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/image/logo/logo.png', height: 100),
                const SizedBox(height: 24),

                const Text(
                  '팩업과 함께 여행을 떠나보세요',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                SocialLoginButton(
                  type: SocialLoginType.google,
                  onPressed: () async {
                    await viewModel.checkLogin(SocialLoginType.google);
                    if (context.mounted &&
                        (viewModel.accessToken?.isNotEmpty ?? false)) {
                      context.go('/index');
                    }
                  },
                ),
                const SizedBox(height: 12),

                SocialLoginButton(
                  type: SocialLoginType.kakao,
                  onPressed: () async {
                    await viewModel.checkLogin(SocialLoginType.kakao);
                    if (context.mounted &&
                        (viewModel.accessToken?.isNotEmpty ?? false)) {
                      context.go('/index');
                    }
                  },
                ),

                const SizedBox(height: 64),

                Text.rich(
                  TextSpan(
                    text: '가입함으로써, 귀하는 당사의 이용 약관에 동의하고, 개인정보 ',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    children: [
                      TextSpan(
                        text: '보호정책을 인정하며',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                // 보호정책 링크로 이동
                              },
                      ),
                      const TextSpan(text: ', 18세 이상임을 확인합니다.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

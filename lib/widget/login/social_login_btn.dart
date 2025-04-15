import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:packup/const/image.dart';

enum SocialLoginType { kakao, google }

class SocialLoginButton extends StatelessWidget {

  final SocialLoginType type;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {Key? key, required this.type, required this.onPressed}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      // 카카오 로그인 버튼 UI
      case SocialLoginType.kakao:
        return Center(
          child: GestureDetector(
            onTap: onPressed,
            child: Image.asset(
              KAKAO_LOGIN_BTN,
              width: 220,
            ),
          ),
        );
    // 구글 로그인 버튼 UI
      case SocialLoginType.google:
        return Center(
          child: SignInButton(
            Buttons.Google,
            text: "Google로 로그인",
            onPressed: onPressed,
          ),
        );
    }
  }
}

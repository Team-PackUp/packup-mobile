import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:packup/const/image.dart';

enum SocialLoginType { kakao, google }

class SocialLoginButton extends StatelessWidget {
  final SocialLoginType type;
  final VoidCallback onPressed;

  const SocialLoginButton({
    Key? key,
    required this.type,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SocialLoginType.kakao:
        return SizedBox(
          width: 260,
          height: 45,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFEE500),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/icon/kakao_logo.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 12),
                const Text('카카오 로그인', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );

      case SocialLoginType.google:
        return SizedBox(
          width: 260,
          height: 45,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: Image.asset(
              'assets/icon/google_logo.png',
              width: 24,
              height: 24,
            ),
            label: const Text('Google로 로그인', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: const BorderSide(color: Colors.grey),
              elevation: 0,
            ),
          ),
        );
    }
  }
}

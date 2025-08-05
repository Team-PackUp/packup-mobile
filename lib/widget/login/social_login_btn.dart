import 'package:flutter/material.dart';

enum SocialLoginType { kakao, google }

extension SocialLoginTypeCode on SocialLoginType {
  String get codeNumber {
    switch (this) {
      case SocialLoginType.kakao:
        return '010000';
      case SocialLoginType.google:
        return '010001';
    }
  }
}

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
    final Color backgroundColor =
        type == SocialLoginType.kakao ? const Color(0xFFFEE500) : Colors.white;
    final Color textColor = Colors.black;
    final BorderSide? borderSide =
        type == SocialLoginType.google
            // ? const BorderSide(color: Colors.grey)
            ? null
            : null;
    final String label =
        type == SocialLoginType.kakao ? 'Kakao로 계속하기' : 'Google로 계속하기';
    final String iconPath =
        type == SocialLoginType.kakao
            ? 'assets/icon/kakao_logo.png'
            : 'assets/icon/google_logo.png';

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          side: borderSide,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(iconPath, width: 24, height: 24),
            ),
            Center(child: Text(label, style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }
}

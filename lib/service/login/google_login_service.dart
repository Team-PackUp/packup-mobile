import 'package:google_sign_in/google_sign_in.dart';
import 'package:packup/service/login/social_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io' show Platform;

class GoogleLogin implements SocialLogin {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS ? dotenv.env['IOS_CLIENT_ID'] : null,
    scopes: ['email'],
    hostedDomain: '',
  );

  GoogleSignInAccount? googleUser;

  @override
  Future<bool> login() async {
    try {
      await _googleSignIn.signOut();
      googleUser = await _googleSignIn.signIn();
      return googleUser != null;
    } catch (error) {
      return false;
    }
  }


  @override
  Future<bool> logout() async {
    if (googleUser == null) return false;
      await _googleSignIn.signOut();

      return true;
  }

  @override
  Future<String?> getAccessToken() async {
    if (googleUser == null) return '';
    final googleAuth = await googleUser!.authentication;

    return googleAuth.accessToken;
  }
}
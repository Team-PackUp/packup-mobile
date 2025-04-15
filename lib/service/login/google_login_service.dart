import 'package:google_sign_in/google_sign_in.dart';
import 'package:packup/service/login/social_login.dart';

class GoogleLogin implements SocialLogin {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  GoogleSignInAccount? googleUser;

  @override
  Future<bool> login() async {
    try {
      googleUser = await _googleSignIn.signIn();
      return googleUser != null;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {

      return true;
    } catch(error) {
      return false;
    }
  }

  @override
  Future<String?> getAccessToken() async {
    if (googleUser == null) return '';
    final googleAuth = await googleUser!.authentication;
    return googleAuth.accessToken;
  }
}
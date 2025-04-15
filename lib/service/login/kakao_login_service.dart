import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:packup/service/login/social_login.dart';

class KakaoLogin implements SocialLogin {

  @override
  Future<bool> login()  async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      print(isInstalled);
      if(isInstalled) {
        print("카카오톡 설치");
        try {
          print("카카오톡 앱으로 로그인 시작");
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (error) {
          print("카카오톡 앱으로 로그인 실패");
          try {
            print("카카오 계정으로 로그인 시작");
            await UserApi.instance.loginWithKakaoAccount();
            print("카카오 계정으로 로그인 성공");
            return true;
          } catch(error) {
            print("카카오 계정으로 로그인 실패");
            return false;
          }
        }
      } else {
        print("카카오톡 앱 설치 안되어 있음");
        try {
          print("카카오 계정으로 로그인 시작");
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch(error) {
          print("카카오 계정으로 로그인 실패");
          return false;
        }
      }
    } catch(errror) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch(error) {
      return false;
    }
  }

  @override
  Future<String?> getAccessToken()  async{
    OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
    return token.accessToken;
  }
}
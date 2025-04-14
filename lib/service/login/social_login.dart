abstract class SocialLogin {
  Future<bool> login();
  Future<bool> logout();
  Future<String?> getAccessToken();
}

class LoginModel {
  final String userId;
  final String userPassword;

  LoginModel({
    required this.userId,
    required this.userPassword,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'userNumber'    : userId,
      'userPassword'  : userPassword,
    };
  }
}
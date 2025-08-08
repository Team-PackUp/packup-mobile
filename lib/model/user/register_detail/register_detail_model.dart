class RegisterDetailModel {
  final String userGender;
  final String userBirth;
  final String userNation;
  final String userLanguage;

  RegisterDetailModel({
    required this.userGender,
    required this.userBirth,
    required this.userNation,
    required this.userLanguage,
  });

  Map<String, dynamic> toJson() {
    return {
      'userGender': userGender,
      'userBirth': userBirth,
      'userNation': userNation,
      'userLanguage': userLanguage,
    };
  }
}

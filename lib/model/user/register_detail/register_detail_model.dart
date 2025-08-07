class RegisterDetailModel {
  final String userGender;
  final String userAge;
  final String userNation;
  final String userLanguage;

  RegisterDetailModel({
    required this.userGender,
    required this.userAge,
    required this.userNation,
    required this.userLanguage,
  });

  Map<String, dynamic> toJson() {
    return {
      'userGender': userGender,
      'userAge': userAge,
      'userNation': userNation,
      'userLanguage': userLanguage,
    };
  }
}

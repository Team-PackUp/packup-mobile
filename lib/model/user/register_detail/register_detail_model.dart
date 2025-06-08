class RegisterDetailModel {
  final String userGender;
  final String userAge;
  final String userNation;

  RegisterDetailModel({
    required this.userGender,
    required this.userAge,
    required this.userNation,
  });

  Map<String, dynamic> toJson() {
    return {
      'userGender': userGender,
      'userAge': userAge,
      'userNation': userNation,
    };
  }
}

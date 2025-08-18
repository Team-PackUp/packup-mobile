class UserProfileModel {
  final String? profileImagePath;
  final String? language;
  final String nickName;
  final String birth;
  final String gender;
  final List<String> preference;

  UserProfileModel({
    this.profileImagePath,
    this.language,
    required this.nickName,
    required this.birth,
    required this.gender,
    required this.preference,
  });

  Map<String, dynamic> toJson() {
    return {
      'profileImagePath': profileImagePath,
      'nickName': nickName,
      'birth': birth,
      'gender': gender,
      'language': language,
      'preference': preference,
    };
  }
}

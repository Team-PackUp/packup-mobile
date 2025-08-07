class UserProfileModel {
  final String? profileImagePath;
  final String nickName;
  final String age;
  final String gender;
  final String language;
  final List<String> preference;

  UserProfileModel({
    this.profileImagePath,
    required this.nickName,
    required this.age,
    required this.gender,
    required this.language,
    required this.preference,
  });

  Map<String, dynamic> toJson() {
    return {
      'profileImagePath': profileImagePath,
      'nickName': nickName,
      'age': age,
      'gender': gender,
      'language': language,
      'preference': preference,
    };
  }
}

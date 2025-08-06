class UserProfileModel {
  final String profileImagePath;
  final String nickName;
  final String language;
  final List<String> preference;

  UserProfileModel({
    required this.profileImagePath,
    required this.nickName,
    required this.language,
    required this.preference,
  });

  Map<String, dynamic> toJson() {
    return {
      'profileImagePath': profileImagePath,
      'nickName': nickName,
      'language': language,
      'preference': preference,
    };
  }
}

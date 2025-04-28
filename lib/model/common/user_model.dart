class UserModel {
  final String userId;
  final String userAge;
  final String userNation;

  final String? email;
  final String? nickname;
  final Map<String, dynamic>? preferCategorySeqJson;

  UserModel({
    required this.userId,
    required this.userAge,
    required this.userNation,

    this.email,
    this.nickname,
    this.preferCategorySeqJson,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userNumber': userId,
      'userAge': userAge,
      'userNation': userNation,
      'email': email,
      'nickname': nickname,
      'preferCategorySeqJson': preferCategorySeqJson,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userNumber'] ?? '',
      userAge: json['userAge'] ?? '',
      userNation: json['userNation'] ?? '',
      email: json['email'],
      nickname: json['nickname'],
      preferCategorySeqJson: json['preferCategorySeqJson'],
    );
  }
}

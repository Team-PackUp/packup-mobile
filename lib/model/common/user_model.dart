class UserModel {
  final String userId;
  final String userAge;
  final String userNation;
  final String joinType;
  final String userGender;
  final String userLanguage;

  final String? email;
  final String? nickname;
  late final String? marketingFlag;
  late final String? pushFlag;
  late final String? profileImagePath;
  final List<String>? preferCategorySeqJson;



  UserModel({
    required this.userId,
    required this.userAge,
    required this.userNation,
    required this.joinType,
    required this.userGender,
    required this.userLanguage,

    this.email,
    this.nickname,
    this.marketingFlag,
    this.pushFlag,
    this.profileImagePath,
    this.preferCategorySeqJson,

  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userNumber': userId,
      'userAge': userAge,
      'userNation': userNation,
      'email': email,
      'nickname': nickname,
      'userLanguage': userLanguage,
      'preferCategorySeqJson': preferCategorySeqJson,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      userAge: json['age']?.toString() ?? '',
      userNation: json['nation'] ?? '',
      joinType: json['joinType'] ?? '',
      userGender: json['gender'] ?? '',
      email: json['email'],
      nickname: json['nickname'],
      marketingFlag: json['marketingFlag'],
      pushFlag: json['pushFlag'],
      profileImagePath: json['profileImagePath'],
      userLanguage: json['language'],
      preferCategorySeqJson:
          (json['preferCategorySeqJson'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
    );
  }
}

extension UserModelExtension on UserModel {
  bool get isDetailRegistered {
    return userAge.isNotEmpty &&
        userNation.isNotEmpty &&
        userGender.isNotEmpty &&
        nickname != null &&
        nickname!.isNotEmpty;
  }

  bool get hasPreferenceSet {
    return preferCategorySeqJson != null && preferCategorySeqJson!.isNotEmpty;
  }
}

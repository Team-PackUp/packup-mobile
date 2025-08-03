class UserModel {
  final String userId;
  final String userAge;
  final String userNation;
  final String userGender;

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
    required this.userGender,

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
      'preferCategorySeqJson': preferCategorySeqJson,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      userAge: json['age']?.toString() ?? '',
      userNation: json['nation'] ?? '',
      userGender: json['gender'] ?? '',
      email: json['email'],
      nickname: json['nickname'],
      marketingFlag: json['marketingFlag'],
      pushFlag: json['pushFlag'],
      profileImagePath: json['profileImagePath'],
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

class GuideModelTemp {
  final int? seq;
  final int? userSeq;
  final String? guideName;
  final String? telNumber;
  final String? telNumber2;
  final List<String>? languages;
  final String? guideIntroduce;
  final double? guideRating;
  final String? guideAvatarPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? desc;
  final int? tours;
  final String? image;
  final String? name;

  GuideModelTemp({
    this.seq,
    this.userSeq,
    this.guideName,
    this.telNumber,
    this.telNumber2,
    this.languages,
    this.guideIntroduce,
    this.guideRating,
    this.guideAvatarPath,
    this.createdAt,
    this.updatedAt,
    this.desc,
    this.tours,
    this.image,
    this.name,
  });

  factory GuideModelTemp.fromJson(Map<String, dynamic> json) {
    return GuideModelTemp(
      seq: json['seq'],
      userSeq: json['userSeq'],
      guideName: json['guideName'],
      telNumber: json['telNumber'],
      telNumber2: json['telNumber2'],
      languages: (json['languages'] as List?)?.cast<String>(),
      guideIntroduce: json['guideIntroduce'],
      guideRating: (json['guideRating'] as num?)?.toDouble(),
      guideAvatarPath: json['guideAvatarPath'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'userSeq': userSeq,
      'guideName': guideName,
      'telNumber': telNumber,
      'telNumber2': telNumber2,
      'languages': languages,
      'guideIntroduce': guideIntroduce,
      'guideRating': guideRating,
      'guideAvatarPath': guideAvatarPath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory GuideModelTemp.empty() {
    return GuideModelTemp(
      seq: null,
      userSeq: null,
      guideName: '',
      telNumber: '',
      telNumber2: '',
      languages: const [],
      guideIntroduce: '',
      guideRating: 0.0,
      guideAvatarPath: '',
      createdAt: null,
      updatedAt: null,
    );
  }
}

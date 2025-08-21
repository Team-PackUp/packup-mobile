class GuideIntroModel {
  final String years;
  final String roleSummary;
  final String expertise;
  final String achievement;
  final String summary;

  GuideIntroModel({
    required this.years,
    required this.roleSummary,
    required this.expertise,
    required this.achievement,
    required this.summary,
  });

  factory GuideIntroModel.empty() => GuideIntroModel(
    years: '',
    roleSummary: '',
    expertise: '',
    achievement: '',
    summary: '',
  );

  factory GuideIntroModel.fromJson(Map<String, dynamic> j) => GuideIntroModel(
    years: (j['years'] ?? '').toString(),
    roleSummary: (j['roleSummary'] ?? '').toString(),
    expertise: (j['expertise'] ?? '').toString(),
    achievement: (j['achievement'] ?? '').toString(),
    summary: (j['summary'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {
    'years': int.tryParse(years.trim()) ?? 0,
    'roleSummary': roleSummary,
    'expertise': expertise,
    'achievement': achievement,
    'summary': summary,
  };

  GuideIntroModel copyWith({
    String? years,
    String? roleSummary,
    String? expertise,
    String? achievement,
    String? summary,
  }) {
    return GuideIntroModel(
      years: years ?? this.years,
      roleSummary: roleSummary ?? this.roleSummary,
      expertise: expertise ?? this.expertise,
      achievement: achievement ?? this.achievement,
      summary: summary ?? this.summary,
    );
  }
}

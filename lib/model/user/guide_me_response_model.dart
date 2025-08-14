class GuideMeResponseModel {
  final bool isGuide;
  final Map<String, dynamic>? guide;

  GuideMeResponseModel({required this.isGuide, this.guide});

  factory GuideMeResponseModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return GuideMeResponseModel(
        isGuide: json['isGuide'] == true,
        guide:
            json['guide'] is Map<String, dynamic>
                ? (json['guide'] as Map<String, dynamic>)
                : null,
      );
    }

    if (json is bool) return GuideMeResponseModel(isGuide: json, guide: null);
    return GuideMeResponseModel(isGuide: false, guide: null);
  }
}

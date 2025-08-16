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
/**
 * 이미 지원서를 작성했다면?
 * 작성했지만 승인이 안돼서 기다리고 있다면? 
 * 토스트로 보여 줘야 할 듯
 * 이러면 지원서가 있는지도 함께 확인해야하는데. 지원서에 대한 상태도 있을듯 
 */
/**
 * 
 */
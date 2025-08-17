class MyGuideStatusResponseModel {
  final bool isGuide;
  final ApplicationPart application;

  const MyGuideStatusResponseModel({
    required this.isGuide,
    required this.application,
  });

  factory MyGuideStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return MyGuideStatusResponseModel(
      isGuide: json['isGuide'] == true,
      application: ApplicationPart.fromJson(
        (json['application'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'isGuide': isGuide,
    'application': application.toJson(),
  };
}

class ApplicationPart {
  final bool exists;
  final String? statusCode;
  final String? statusName;
  final String? rejectReason;
  final bool canReapply;

  const ApplicationPart({
    required this.exists,
    required this.statusCode,
    required this.statusName,
    required this.rejectReason,
    required this.canReapply,
  });

  factory ApplicationPart.fromJson(Map<String, dynamic> json) {
    return ApplicationPart(
      exists: json['exists'] == true,
      statusCode: json['statusCode'] as String?,
      statusName: json['statusName'] as String?,
      rejectReason: json['rejectReason'] as String?,
      canReapply: json['canReapply'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'exists': exists,
    'statusCode': statusCode,
    'statusName': statusName,
    'rejectReason': rejectReason,
    'canReapply': canReapply,
  };
}

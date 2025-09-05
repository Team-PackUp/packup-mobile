class TourSessionCreateRequest {
  final DateTime sessionStartTime;
  final DateTime sessionEndTime;

  const TourSessionCreateRequest({
    required this.sessionStartTime,
    required this.sessionEndTime,
  });

  Map<String, dynamic> toJson() => {
    'sessionStartTime': sessionStartTime.toUtc().toIso8601String(),
    'sessionEndTime': sessionEndTime.toUtc().toIso8601String(),
  };
}

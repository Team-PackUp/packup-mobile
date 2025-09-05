class TourSessionCreateRequest {
  final int tourSeq;
  final DateTime sessionStartTime;
  final DateTime sessionEndTime;

  const TourSessionCreateRequest({
    required this.tourSeq,
    required this.sessionStartTime,
    required this.sessionEndTime,
  });

  Map<String, dynamic> toJson() => {
    'tourSeq': tourSeq,
    'sessionStartTime': sessionStartTime.toIso8601String(),
    'sessionEndTime': sessionEndTime.toIso8601String(),
  };
}

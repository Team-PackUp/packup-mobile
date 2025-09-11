class TourSessionCreateRequest {
  final int tourSeq;
  final DateTime sessionStartTime;
  final DateTime sessionEndTime;
  final int maxParticipants;

  const TourSessionCreateRequest({
    required this.tourSeq,
    required this.sessionStartTime,
    required this.sessionEndTime,
    required this.maxParticipants,
  });

  Map<String, dynamic> toJson() => {
    'tourSeq': tourSeq,
    'sessionStartTime': sessionStartTime.toIso8601String(),
    'sessionEndTime': sessionEndTime.toIso8601String(),
    'maxParticipants': maxParticipants,
  };
}

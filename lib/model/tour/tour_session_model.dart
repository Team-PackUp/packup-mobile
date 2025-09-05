import 'package:packup/const/tour/tour_session_status_code.dart';

class TourSessionModel {
  final int seq;
  final int tourSeq;
  final DateTime startTime;
  final DateTime endTime;
  final TourSessionStatusCode status;
  final int? capacity;
  final int? bookedCount;
  final DateTime? cancelledAt;

  TourSessionModel({
    required this.seq,
    required this.tourSeq,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.capacity,
    this.bookedCount,
    this.cancelledAt,
  });

  factory TourSessionModel.fromJson(Map<String, dynamic> j) {
    return TourSessionModel(
      seq: j['seq'] as int,
      tourSeq: j['tourSeq'] as int,
      startTime: DateTime.parse(j['sessionStartTime'] as String),
      endTime: DateTime.parse(j['sessionEndTime'] as String),
      status: TourSessionStatusCode.from(j['sessionStatusCode'] as int),
      capacity: j['capacity'] as int?,
      bookedCount: j['bookedCount'] as int?,
      cancelledAt:
          j['cancelledAt'] != null ? DateTime.parse(j['cancelledAt']) : null,
    );
  }
}

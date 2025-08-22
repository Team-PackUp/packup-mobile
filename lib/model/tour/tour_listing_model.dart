import 'package:intl/intl.dart';

enum TourListingStatus { inProgress, published, paused }

class TourListingModel {
  final int id;
  final String titleKo;
  final String? titleEn;
  final String categoryKo;
  final String? categoryEn;
  final String? coverImagePath;
  final DateTime? startDate;
  final TourListingStatus status;

  TourListingModel({
    required this.id,
    required this.titleKo,
    this.titleEn,
    required this.categoryKo,
    this.categoryEn,
    this.coverImagePath,
    this.startDate,
    required this.status,
  });

  factory TourListingModel.fromJson(Map<String, dynamic> j) => TourListingModel(
    id: j['id'],
    titleKo: j['titleKo'] ?? j['title'] ?? '',
    titleEn: j['titleEn'],
    categoryKo: j['categoryKo'] ?? j['categoryNameKo'] ?? '',
    categoryEn: j['categoryEn'] ?? j['categoryNameEn'],
    coverImagePath: j['coverImagePath'],
    startDate: j['startDate'] != null ? DateTime.parse(j['startDate']) : null,
    status: _statusFrom(j['status']),
  );

  static TourListingStatus _statusFrom(dynamic v) {
    switch ((v ?? '').toString().toUpperCase()) {
      case 'PUBLISHED':
        return TourListingStatus.published;
      case 'PAUSED':
        return TourListingStatus.paused;
      default:
        return TourListingStatus.inProgress;
    }
  }

  String get statusKo {
    switch (status) {
      case TourListingStatus.published:
        return '게시 중';
      case TourListingStatus.paused:
        return '일시중지';
      case TourListingStatus.inProgress:
        return '진행 중';
    }
  }

  String formattedStartKo() {
    if (startDate == null) return '';
    final f = DateFormat('yyyy년 M월 d일');
    return f.format(startDate!);
  }
}

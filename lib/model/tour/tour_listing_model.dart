import 'package:intl/intl.dart';

enum TourListingStatus { published, paused, inProgress }

class TourListingModel {
  final int id;
  final String titleKo;
  final String? titleEn;
  final String categoryKo;
  final String? categoryEn;
  final String? coverImagePath;
  final DateTime? startDate;

  final String? statusCode;
  final TourListingStatus? legacyStatus;

  TourListingModel({
    required this.id,
    required this.titleKo,
    this.titleEn,
    required this.categoryKo,
    this.categoryEn,
    this.coverImagePath,
    this.startDate,
    this.statusCode,
    this.legacyStatus,
  });

  factory TourListingModel.fromJson(Map<String, dynamic> j) {
    final String? rawStatusCode =
        (j['statusCode'] ?? j['tourStatusCode'] ?? j['status'])?.toString();

    final String? normalizedCode = _normalizeStatusCode(rawStatusCode);

    return TourListingModel(
      id: j['id'] as int,
      titleKo: (j['titleKo'] ?? j['title'] ?? '') as String,
      titleEn: j['titleEn'] as String?,
      categoryKo: (j['categoryKo'] ?? j['categoryNameKo'] ?? '') as String,
      categoryEn: j['categoryEn'] ?? j['categoryNameEn'] as String?,
      coverImagePath: j['coverImagePath'] as String?,
      startDate: j['startDate'] != null ? DateTime.parse(j['startDate']) : null,
      statusCode: normalizedCode,
      legacyStatus: normalizedCode == null ? _legacyFrom(rawStatusCode) : null,
    );
  }

  String get statusKo {
    if (statusCode != null) {
      switch (statusCode) {
        case 'TEMP':
          return '임시저장';
        case 'RECRUITING':
          return '모집중';
        case 'RECRUITED':
          return '모집완료';
        case 'READY':
          return '출발대기';
        case 'ONGOING':
          return '투어중';
        case 'FINISHED':
          return '종료';
      }
    }
    switch (legacyStatus) {
      case TourListingStatus.published:
        return '게시 중';
      case TourListingStatus.paused:
        return '일시중지';
      case TourListingStatus.inProgress:
        return '진행 중';
      default:
        return '';
    }
  }

  String get normalizedStatusForBadge =>
      statusCode ??
      (legacyStatus == TourListingStatus.published
          ? 'RECRUITING'
          : legacyStatus == TourListingStatus.paused
          ? 'RECRUITED'
          : 'ONGOING');

  String formattedStartKo() {
    if (startDate == null) return '';
    final f = DateFormat('yyyy년 M월 d일');
    return f.format(startDate!);
  }

  static String? _normalizeStatusCode(String? v) {
    final s = (v ?? '').toUpperCase();
    const codes = {
      'TEMP',
      'RECRUITING',
      'RECRUITED',
      'READY',
      'ONGOING',
      'FINISHED',
    };
    return codes.contains(s) ? s : null;
  }

  static TourListingStatus? _legacyFrom(String? v) {
    switch ((v ?? '').toLowerCase()) {
      case 'published':
        return TourListingStatus.published;
      case 'paused':
        return TourListingStatus.paused;
      case 'inprogress':
        return TourListingStatus.inProgress;
      default:
        return null;
    }
  }
}

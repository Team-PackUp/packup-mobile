import 'package:flutter/foundation.dart';

@immutable
class TourCreateRequest {
  final List<String> tourKeywords;
  final String tourTitle;
  final String tourIntroduce;
  final String tourIncludedContent;
  final String tourExcludedContent;
  final String? tourNotes;
  final int? tourLocationCode;
  final String? tourThumbnailUrl;
  final int tourPrice;
  final int? minHeadCount;
  final int? maxHeadCount;
  final String? meetUpAddress;
  final double? meetUpLat;
  final double? meetUpLng;
  final String transportServiceFlag; // 'Y' | 'N'
  final String privateFlag; // 'Y' | 'N'
  final int? privatePrice;
  final String adultContentFlag; // 'Y' | 'N'
  final String tourStatusCode; // 예: '100001' (TEMP)
  final String? memo;

  final List<ActivityCreateReq> activities;
  final List<String> photos; // 선택 전송용

  const TourCreateRequest({
    required this.tourKeywords,
    required this.tourTitle,
    required this.tourIntroduce,
    required this.tourIncludedContent,
    required this.tourExcludedContent,
    this.tourNotes,
    this.tourLocationCode,
    this.tourThumbnailUrl,
    required this.tourPrice,
    this.minHeadCount,
    this.maxHeadCount,
    this.meetUpAddress,
    this.meetUpLat,
    this.meetUpLng,
    required this.transportServiceFlag,
    required this.privateFlag,
    this.privatePrice,
    this.adultContentFlag = 'N',
    this.tourStatusCode = '100001', // TEMP
    this.memo,
    this.activities = const [],
    this.photos = const [],
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'tourKeywords': tourKeywords,
      'tourTitle': tourTitle,
      'tourIntroduce': tourIntroduce,
      'tourIncludedContent': tourIncludedContent,
      'tourExcludedContent': tourExcludedContent,
      'tourNotes': tourNotes,
      'tourLocationCode': tourLocationCode,
      'tourThumbnailUrl': tourThumbnailUrl,
      'tourPrice': tourPrice,
      'minHeadCount': minHeadCount,
      'maxHeadCount': maxHeadCount,
      'meetUpAddress': meetUpAddress,
      'meetUpLat': meetUpLat,
      'meetUpLng': meetUpLng,
      'transportServiceFlag': transportServiceFlag,
      'privateFlag': privateFlag,
      'privatePrice': privatePrice,
      'adultContentFlag': adultContentFlag,
      'tourStatusCode': tourStatusCode,
      'memo': memo,
      'activities': activities.map((e) => e.toJson()).toList(),
      'photos': photos,
    };
    map.removeWhere((k, v) => v == null);
    return map;
  }
}

@immutable
class ActivityCreateReq {
  final int activityOrder;
  final String activityTitle;
  final String? activityIntroduce;
  final int? activityDurationMinute;
  final List<ActivityThumbCreateReq> thumbnails;

  const ActivityCreateReq({
    required this.activityOrder,
    required this.activityTitle,
    this.activityIntroduce,
    this.activityDurationMinute,
    this.thumbnails = const [],
  });

  Map<String, dynamic> toJson() => {
    'activityOrder': activityOrder,
    'activityTitle': activityTitle,
    'activityIntroduce': activityIntroduce,
    'activityDurationMinute': activityDurationMinute,
    'thumbnails': thumbnails.map((e) => e.toJson()).toList(),
  }..removeWhere((k, v) => v == null);
}

@immutable
class ActivityThumbCreateReq {
  final int thumbnailOrder;
  final String thumbnailImageUrl;

  const ActivityThumbCreateReq({
    required this.thumbnailOrder,
    required this.thumbnailImageUrl,
  });

  Map<String, dynamic> toJson() => {
    'thumbnailOrder': thumbnailOrder,
    'thumbnailImageUrl': thumbnailImageUrl,
  };
}

// lib/model/tour/tour_model.dart
import 'dart:convert';

import 'package:packup/model/guide/guide_model.dart';

/// 투어 정보를 담는 데이터 모델입니다.
/// API로부터 받아오거나 서버로 전송하는 데 사용됩니다.
class TourModel {
  /// 투어 고유 번호
  final int? seq;

  /// 가이드 고유 번호
  final GuideModel? guide;

  /// 최소 인원
  final int? minPeople;

  /// 최대 인원
  final int? maxPeople;

  /// 신청 시작일
  final DateTime? applyStartDate;

  /// 신청 종료일
  final DateTime? applyEndDate;

  /// 투어 시작일
  final DateTime? tourStartDate;

  /// 투어 종료일
  final DateTime? tourEndDate;

  /// 투어 제목
  final String? tourTitle;

  /// 투어 제목
  final int? tourPrice;

  /// 투어 소개
  final String? tourIntroduce;

  /// 투어 상태 코드 (예: '100001')
  final String? tourStatusCode;

  /// 투어 상태 라벨 (예: '모집중')
  final String? tourStatusLabel;

  /// 투어 위치
  final String? tourLocation;

  /// 대표 이미지 경로
  final String? titleImagePath;

  /// 생성일
  final DateTime? createdAt;

  /// 수정일
  final DateTime? updatedAt;

  /// 기본 생성자
  TourModel({
    this.seq,
    this.guide,
    this.minPeople,
    this.maxPeople,
    this.applyStartDate,
    this.applyEndDate,
    this.tourStartDate,
    this.tourEndDate,
    this.tourTitle,
    this.tourPrice,
    this.tourIntroduce,
    this.tourStatusCode,
    this.tourStatusLabel,
    this.tourLocation,
    this.titleImagePath,
    this.createdAt,
    this.updatedAt,
  });

  /// JSON 데이터를 모델로 변환합니다.
  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      seq: json['seq'],
      guide: json['guide'] != null ? GuideModel.fromJson(json['guide']) : null,
      minPeople: json['minPeople'],
      maxPeople: json['maxPeople'],
      applyStartDate: json['applyStartDate'] != null ? DateTime.parse(json['applyStartDate']) : null,
      applyEndDate: json['applyEndDate'] != null ? DateTime.parse(json['applyEndDate']) : null,
      tourStartDate: json['tourStartDate'] != null ? DateTime.parse(json['tourStartDate']) : null,
      tourEndDate: json['tourEndDate'] != null ? DateTime.parse(json['tourEndDate']) : null,
      tourTitle: json['tourTitle'],
      tourPrice: json['tourPrice'],
      tourIntroduce: json['tourIntroduce'],
      tourStatusCode: json['tourStatusCode'],
      tourStatusLabel: json['tourStatusLabel'],
      tourLocation: json['tourLocation'],
      titleImagePath: json['titleImagePath'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  /// 모델을 JSON 형태로 변환합니다.
  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'guide': guide?.toJson(),
      'minPeople': minPeople,
      'maxPeople': maxPeople,
      'applyStartDate': applyStartDate?.toIso8601String(),
      'applyEndDate': applyEndDate?.toIso8601String(),
      'tourStartDate': tourStartDate?.toIso8601String(),
      'tourEndDate': tourEndDate?.toIso8601String(),
      'tourTitle': tourTitle,
      'tourPrice': tourPrice,
      'tourIntroduce': tourIntroduce,
      'tourStatusCode': tourStatusCode,
      'tourStatusLabel': tourStatusLabel,
      'tourLocation': tourLocation,
      'titleImagePath': titleImagePath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// 빈 모델 인스턴스를 생성합니다.
  /// 신규 등록 시 사용됩니다.
  factory TourModel.empty() {
    return TourModel(
      seq: null,
      guide: GuideModel.empty(),
      minPeople: 1,
      maxPeople: 1,
      applyStartDate: null,
      applyEndDate: null,
      tourStartDate: null,
      tourEndDate: null,
      tourTitle: '',
      tourPrice: 0,
      tourIntroduce: '',
      tourStatusCode: '',
      tourStatusLabel: '',
      tourLocation: '',
      titleImagePath: '',
      createdAt: null,
      updatedAt: null,
    );
  }
}

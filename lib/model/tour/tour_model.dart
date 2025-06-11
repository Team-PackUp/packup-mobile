// lib/model/tour/tour_model.dart
import 'dart:convert';

class TourModel {
  final int? seq;
  final int? guideSeq;
  final int? minPeople;
  final int? maxPeople;
  final DateTime? applyStartDate;
  final DateTime? applyEndDate;
  final DateTime? tourStartDate;
  final DateTime? tourEndDate;
  final String? tourTitle;
  final String? tourIntroduce;
  final String? tourStatusCode;
  final String? tourStatusLabel;
  final String? tourLocation;
  final String? titleImagePath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TourModel({
    this.seq,
    this.guideSeq,
    this.minPeople,
    this.maxPeople,
    this.applyStartDate,
    this.applyEndDate,
    this.tourStartDate,
    this.tourEndDate,
    this.tourTitle,
    this.tourIntroduce,
    this.tourStatusCode,
    this.tourStatusLabel,
    this.tourLocation,
    this.titleImagePath,
    this.createdAt,
    this.updatedAt,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      seq: json['seq'],
      guideSeq: json['guideSeq'],
      minPeople: json['minPeople'],
      maxPeople: json['maxPeople'],
      applyStartDate: json['applyStartDate'] != null ? DateTime.parse(json['applyStartDate']) : null,
      applyEndDate: json['applyEndDate'] != null ? DateTime.parse(json['applyEndDate']) : null,
      tourStartDate: json['tourStartDate'] != null ? DateTime.parse(json['tourStartDate']) : null,
      tourEndDate: json['tourEndDate'] != null ? DateTime.parse(json['tourEndDate']) : null,
      tourTitle: json['tourTitle'],
      tourIntroduce: json['tourIntroduce'],
      tourStatusCode: json['tourStatusCode'],
      tourStatusLabel: json['tourStatusLabel'],
      tourLocation: json['tourLocation'],
      titleImagePath: json['titleImagePath'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'guideSeq': guideSeq,
      'minPeople': minPeople,
      'maxPeople': maxPeople,
      'applyStartDate': applyStartDate?.toIso8601String(),
      'applyEndDate': applyEndDate?.toIso8601String(),
      'tourStartDate': tourStartDate?.toIso8601String(),
      'tourEndDate': tourEndDate?.toIso8601String(),
      'tourIntroduce': tourIntroduce,
      'tourStatusCode': tourStatusCode,
      'tourStatusLabel': tourStatusLabel,
      'tourLocation': tourLocation,
      'titleImagePath': titleImagePath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory TourModel.empty() {
    return TourModel(
      seq: null,
      guideSeq: null,
      minPeople: null,
      maxPeople: null,
      applyStartDate: null,
      applyEndDate: null,
      tourStartDate: null,
      tourEndDate: null,
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

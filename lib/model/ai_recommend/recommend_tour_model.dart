// lib/model/ai_recommend/recommend_tour_model.dart
// ----------------------------------------------------
// 백엔드 RecommendResponse.tour 객체 매핑용 모델
// ----------------------------------------------------
import 'dart:convert';

class RecommendTourModel {
  final int? seq;
  final String? tourTitle;
  final String? tourIntroduce;
  final String? titleImagePath;
  final DateTime? applyStartDate;

  RecommendTourModel({
    this.seq,
    this.tourTitle,
    this.tourIntroduce,
    this.titleImagePath,
    this.applyStartDate,
  });

  // JSON → Model
  factory RecommendTourModel.fromJson(Map<String, dynamic> json) {
    return RecommendTourModel(
      seq: json['seq'],
      tourTitle: json['tourTitle'],
      tourIntroduce: json['tourIntroduce'],
      titleImagePath: json['titleImagePath'],
      applyStartDate: json['applyStartDate'] != null
          ? DateTime.parse(json['applyStartDate'])
          : null,
    );
  }
}

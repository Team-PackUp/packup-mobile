
import 'package:packup/model/guide/guide_model.dart';

class RecommendTourModel {
  final int? seq;
  final String? tourTitle;
  final int? minPeople;
  final int? maxPeople;
  final int? tourPrice;
  final String? tourIntroduce;
  final String? tourLocation;
  final String? titleImagePath;
  final DateTime? applyStartDate;

  final GuideModel? guideModel;

  const RecommendTourModel({
    this.seq,
    this.tourTitle,
    this.minPeople,
    this.maxPeople,
    this.tourPrice,
    this.tourLocation,
    this.tourIntroduce,
    this.titleImagePath,
    this.applyStartDate,
    this.guideModel,
  });

  int get remainPeople =>
      (maxPeople ?? 0) - (minPeople ?? 0);

  // JSON → Model
  factory RecommendTourModel.fromJson(Map<String, dynamic> json) {
    return RecommendTourModel(
      seq: json['seq'],
      tourTitle: json['tourTitle'],
      minPeople: json['minPeople'],
      maxPeople: json['maxPeople'],
      tourPrice: json['tourPrice'],
      tourLocation: json['tourLocation'],
      tourIntroduce: json['tourIntroduce'],
      titleImagePath: json['titleImagePath'],
      applyStartDate: json['applyStartDate'] != null
          ? DateTime.parse(json['applyStartDate'])
          : null,
      guideModel: json['guide'] != null
          ? GuideModel.fromJson(json['guide'] as Map<String, dynamic>)
          : null,
    );
  }
}

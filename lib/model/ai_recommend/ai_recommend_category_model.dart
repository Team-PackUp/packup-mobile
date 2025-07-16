import 'dart:convert';
import 'package:flutter/material.dart';

class AIRecommendCategoryModel {
  final int seq;           // 카테고리 고유 번호
  final String name;      // 카테고리 이름
  final IconData icon;    // 머테리얼 아이콘

  AIRecommendCategoryModel({
    required this.seq,
    required this.name,
    required this.icon,
  });

  Map<String, dynamic> toMap() => {
    'seq': seq,
    'name': name,
    'icon': icon.codePoint,
  };

  String toJson() => jsonEncode(toMap());

  factory AIRecommendCategoryModel.fromMap(Map<String, dynamic> map) {
    return AIRecommendCategoryModel(
      seq: map['seq'] as int,
      name: map['name'] as String,
      icon: IconData(
        map['icon'] as int,
        fontFamily: 'MaterialIcons',
      ),
    );
  }

  factory AIRecommendCategoryModel.fromJson(String source) => AIRecommendCategoryModel.fromMap(jsonDecode(source));
}

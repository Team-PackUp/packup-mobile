// lib/model/ai_recommend/category_model.dart
// ----------------------------------------------------
// 투어 카테고리 모델 (아이콘 + 이름 중심)
// ----------------------------------------------------
import 'dart:convert';
import 'package:flutter/material.dart';

class CategoryModel {
  final int seq;           // 카테고리 고유 번호
  final String name;      // 카테고리 이름
  final IconData icon;    // 머테리얼 아이콘

  CategoryModel({
    required this.seq,
    required this.name,
    required this.icon,
  });

  /// JSON 직렬화 (IconData → codePoint 로 저장)
  Map<String, dynamic> toMap() => {
    'seq': seq,
    'name': name,
    'icon': icon.codePoint,
  };

  String toJson() => jsonEncode(toMap());

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      seq: map['seq'] as int,
      name: map['name'] as String,
      icon: IconData(
        map['icon'] as int,
        fontFamily: 'MaterialIcons',
      ),
    );
  }

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(jsonDecode(source));
}

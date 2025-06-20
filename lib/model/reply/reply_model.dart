import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

enum TargetType {
  @JsonValue('REPLY_TOUR')
  replyTour,

  @JsonValue('REPLY_GUIDE')
  replyGuide,
}

extension TargetTypeX on TargetType {
  String get code => switch (this) {
    TargetType.replyTour  => 'REPLY_TOUR',
    TargetType.replyGuide => 'REPLY_GUIDE',
  };

  String get label => switch (this) {
    TargetType.replyTour  => '관광',
    TargetType.replyGuide => '가이드',
  };
}

class ReplyModel {
  final int? seq;
  final int? userSeq;
  final int targetSeq;
  final TargetType targetType;
  final String content;
  final DateTime createdAt;

  ReplyModel({
    this.seq,
    this.userSeq,
    required this.targetSeq,
    required this.targetType,
    required this.content,
    required this.createdAt,
  });

  String toJson() => jsonEncode({
    'seq'        : seq,
    'userSeq'    : userSeq,
    'target_seq' : targetSeq,
    'target_type': targetType.code,
    'content'    : content,
    'createdAt'  : createdAt.toIso8601String(),
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) => ReplyModel(
    seq       : json['seq'],
    userSeq   : json['userSeq'],
    targetSeq : json['target_seq'],
    targetType: TargetType.values
        .firstWhere((e) => e.code == json['target_type']),
    content   : json['content'] ?? '',
    createdAt : json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
  );
}

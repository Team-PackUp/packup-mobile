import 'dart:convert';

enum TargetType { REPLY_TOUR, REPLY_GUIDE }

class ReplyModel {
  final int? seq;
  final int? userSeq;
  final int? targetSeq;
  final TargetType? targetType;
  final String? content;
  final DateTime? createdAt;

  ReplyModel({
    this.seq,
    this.userSeq,
    this.targetSeq,
    this.targetType,
    this.content,
    this.createdAt,
  });

  String toJson() {
    return jsonEncode({
      'target_seq': targetSeq,
      'target_type': targetType,
      'content': content,
    });
  }

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      seq: json['seq'],
      userSeq: json['userSeq'],
      content: json['content'].toString(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

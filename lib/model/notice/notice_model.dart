import 'dart:convert';

class NoticeModel {
  final int? seq;
  final String? title;
  final int? content;
  final DateTime? createdAt;

  NoticeModel({
    this.seq,
    this.title,
    this.content,
    this.createdAt,
  });

  String toJson() {
    return jsonEncode({
      'title': title,
      'content': content,
    });
  }

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      seq: json['seq'],
      title: json['title'],
      content: json['content'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

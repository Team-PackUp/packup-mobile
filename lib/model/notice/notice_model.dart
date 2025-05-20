import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

class NoticeModel {
  final int? seq;
  final String? title;
  final String? content;
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
      content: json['content'].toString(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  factory NoticeModel.empty() {
    return NoticeModel(title: "", content: "");
  }

  Document get quillDocument {
    if (content == null || content!.isEmpty) {
      return Document();
    }
    try {
      final deltaJson = jsonDecode(content!);
      final delta = Delta.fromJson(deltaJson);
      return Document.fromDelta(delta);
    } catch (e) {
      return Document();
    }
  }
}

import 'dart:convert';

class RecommendGuideModel {
  final int? seq;
  final String? message;
  final int? userSeq;
  final int? chatRoomSeq;
  final String? profileImagePath;
  final DateTime? createdAt;
  final String? fileFlag;

  RecommendGuideModel({
    this.seq,
    this.createdAt,
    this.message,
    this.userSeq,
    this.chatRoomSeq,
    this.profileImagePath,
    this.fileFlag,
  });

  String toJson() {
    return jsonEncode({
      'message': message,
      'userSeq': userSeq,
      'chatRoomSeq': chatRoomSeq,
      'fileFlag': fileFlag,
    });
  }

  factory RecommendGuideModel.fromJson(Map<String, dynamic> json) {
    return RecommendGuideModel(
      seq: json['seq'],
      message: json['message'],
      userSeq: json['userSeq'],
      chatRoomSeq: json['chatRoomSeq'],
      profileImagePath: json['profileImagePath'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      fileFlag: json['fileFlag'],
    );
  }
}

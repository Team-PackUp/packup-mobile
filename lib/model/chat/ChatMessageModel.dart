import 'dart:convert';

class ChatMessageModel {
  final int? seq;
  final String? message;
  final int? userSeq;
  final int? chatRoomSeq;
  final DateTime? createdAt;
  final bool? isImage;

  ChatMessageModel({
    this.seq,
    this.createdAt,
    this.message,
    this.userSeq,
    this.chatRoomSeq,
    this.isImage,
  });

  String toJson() {
    return jsonEncode({
      'message': message,
      'userSeq': userSeq,
      'chatRoomSeq': chatRoomSeq,
      'isImage': isImage,
    });
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
              seq: json['seq'],
          message: json['message'],
          userSeq: json['userSeq'],
      chatRoomSeq: json['chatRoomSeq'],
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

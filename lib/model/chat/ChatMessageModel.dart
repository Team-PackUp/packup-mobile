import 'dart:convert';

class ChatMessageModel {
  final int? seq;
  final String? message;
  final int? userSeq;
  final int? chatRoomSeq;
  final DateTime? createdAt;

  ChatMessageModel({
    this.seq,
    this.createdAt,
    this.message,
     this.userSeq,
    this.chatRoomSeq,
  });

  String toJson() {
    return jsonEncode({
      'message': message,
      'userSeq': userSeq,
      'chatRoomSeq': chatRoomSeq,
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

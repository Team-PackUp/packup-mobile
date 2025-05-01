import 'dart:convert';

class ChatMessageModel {
  final int? seq;
  final String? message;
  final int? sender;
  final int? chatRoomSeq;
  final DateTime? createdAt;

  ChatMessageModel({
    this.seq,
    this.createdAt,
    this.message,
     this.sender,
    this.chatRoomSeq,
  });

  String toJson() {
    return jsonEncode({
      'message': message,
      'sender': sender,
      'chatRoomSeq': chatRoomSeq,
    });
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
              seq: json['seq'],
          message: json['message'],
           sender: json['sender'],
      chatRoomSeq: json['chatRoomSeq'],
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

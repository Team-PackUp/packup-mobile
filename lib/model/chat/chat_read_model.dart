import 'dart:convert';

class ChatReadModel {
  final int? seq;
  final int? userSeq;
  final int? chatRoomSeq;
  final int? lastReadMessageSeq;
  final DateTime? createdAt;

  // 생성자
  ChatReadModel({
    this.seq,
    this.userSeq,
    this.chatRoomSeq,
    this.lastReadMessageSeq,
    this.createdAt,
  });

  String toJson() {
    return jsonEncode({
      'chatRoomSeq': chatRoomSeq,
      'lastReadMessageSeq': lastReadMessageSeq,
    });
  }

  factory ChatReadModel.fromJson(Map<String, dynamic> json) {
    return ChatReadModel(
              seq: json['seq'],
          userSeq: json['userSeq'],
      chatRoomSeq: json['chatRoomSeq'],
      lastReadMessageSeq: json['lastReadMessageSeq'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

class ChatMessageModel {
  final int? seq;
  final String message;
  final int sender;
  final int chatRoomSeq;
  final DateTime? createdAt;

  ChatMessageModel({
    this.seq,
    this.createdAt,
    required this.message,
    required this.sender,
    required this.chatRoomSeq,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender': sender,
      'chatRoomSeq': chatRoomSeq,
    };
  }

  factory ChatMessageModel.fromJsonWithBase(
      Map<String, dynamic> json, ChatMessageModel base,
      ) {
    return base.copyWith(
      seq: json['seq'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  ChatMessageModel copyWith({
    int? seq,
    String? message,
    int? sender,
    int? chatRoomSeq,
    DateTime? createdAt,
  }) {
    return ChatMessageModel(
      seq: seq ?? this.seq,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      chatRoomSeq: chatRoomSeq ?? this.chatRoomSeq,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

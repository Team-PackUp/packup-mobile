class ChatMessageModel {
  final String message;
  final int sender;
  final int chatRoomSeq;
  final DateTime? createdAt;

  // 생성자
  ChatMessageModel({
    required this.message,
    required this.sender,
    required this.chatRoomSeq,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'message': message,
      'sender': sender,
      'chatRoomSeq': chatRoomSeq,
      'createdAt': createdAt,
    };
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      message: json['message'] ?? "",
      sender: json['sender'] ?? 0,
      chatRoomSeq: json['chatRoomSeq'] ?? 0,
      createdAt: json['createdAt'] != null && json['createdAt'] != ''
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

}

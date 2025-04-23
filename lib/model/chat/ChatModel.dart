class ChatModel {
  final String? id;
  final String message;
  final int sender;
  final int chatRoomId;
  final String? receiver;
  final String? createdAt;

  // 생성자
  ChatModel({
    required this.id,
    required this.message,
    required this.sender,
    required this.chatRoomId,
    required this.receiver,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'id': id,
      'message': message,
      'sender': sender,
      'chatRoomId': chatRoomId,
      'receiver': receiver,
      'createdAt': createdAt,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json["id"] ?? "",
      message: json['message'] ?? "",
      sender:json['sender'] ?? 0,
      chatRoomId: json['chatRoomId'] ?? 0,
      receiver: json['receiver'] ?? "",
      createdAt: json['createdAt'] ?? "",
    );
  }
}

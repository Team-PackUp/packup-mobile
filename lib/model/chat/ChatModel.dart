class ChatModel {
  final String message;
  final int sender;
  final int chatRoomId;

  // 생성자
  ChatModel({
    required this.message,
    required this.sender,
    required this.chatRoomId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'message': message,
      'sender': sender,
      'chatRoomId': chatRoomId,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      message: json['message'] ?? "",
      sender:json['sender'] ?? 0,
      chatRoomId: json['chatRoomId'] ?? 0,
    );
  }
}

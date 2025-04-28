import 'dart:ffi';

class ChatRoomModel {
  final List<Long> partUserSeq;
  final Long userSeq;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // 생성자
  ChatRoomModel({
    required this.partUserSeq,
    required this.userSeq,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'partUserSeq': partUserSeq,
      'userSeq': userSeq,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      partUserSeq: json['partUserSeq'] ?? "",
      userSeq:json['userSeq'] ?? 0,
      createdAt: json['createdAt'] != null && json['createdAt'] != ''
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null && json['updatedAt'] != ''
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}

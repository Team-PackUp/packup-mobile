class ChatRoomModel {
  final int? seq;
  final List<int> partUserSeq;
  final int userSeq;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // 생성자
  ChatRoomModel({
    this.seq,
    required this.partUserSeq,
    required this.userSeq,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'partUserSeq': partUserSeq,
      'userSeq': userSeq,
    };
  }

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      seq: json['seq'] ?? 0,
      partUserSeq: List<int>.from(json['partUserSeq'] ?? []),
      userSeq: json['userSeq'] ?? 0,
      createdAt: json['createdAt'] != null && json['createdAt'] != ''
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null && json['updatedAt'] != ''
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  ChatRoomModel copyWith({
    int? seq,
    List<int>? partUserSeq,
    int? userSeq,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatRoomModel(
      seq: seq ?? this.seq,
      partUserSeq: partUserSeq ?? this.partUserSeq,
      userSeq: userSeq ?? this.userSeq,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

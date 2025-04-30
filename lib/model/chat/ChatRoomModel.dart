class ChatRoomModel {
  final int? seq;
  final List<int>? partUserSeq;
  final int? userSeq;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // 생성자
  ChatRoomModel({
    this.seq,
    this.partUserSeq,
    this.userSeq,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'partUserSeq': partUserSeq,
      'userSeq': userSeq,
    };
  }

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
              seq: json['seq'],
      partUserSeq: List<int>.from(json['partUserSeq']),
          userSeq: json['userSeq'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

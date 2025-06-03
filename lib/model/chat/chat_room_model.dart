class ChatRoomModel {
  final int? seq;
  final List<int>? partUserSeq;
  final int? userSeq;
  final String? nickNames;
  int? unReadCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // 생성자
  ChatRoomModel({
    this.seq,
    this.partUserSeq,
    this.userSeq,
    this.nickNames,
    this.unReadCount,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'partUserSeq': partUserSeq,
    };
  }

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
              seq: json['seq'],
      partUserSeq: List<int>.from(json['partUserSeq']),
          userSeq: json['userSeq'],
        nickNames: json['nickNames'],
      unReadCount: json['unReadCount'],
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

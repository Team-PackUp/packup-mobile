class ChatRoomModel {
  final int? seq;
  final List<int>? partUserSeq;
  final int? userSeq;
  final String? title;
  int? unReadCount;
  String? lastMessage;
  DateTime? lastMessageDate;
  String? fileFlag;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // 생성자
  ChatRoomModel({
    this.seq,
    this.partUserSeq,
    this.userSeq,
    this.title,
    this.unReadCount,
    this.lastMessage,
    this.lastMessageDate,
    this.fileFlag,
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
            title: json['title'],
      unReadCount: json['unReadCount'],
      lastMessage: json['lastMessage'],
  lastMessageDate: DateTime.parse(json['lastMessageDate']),
         fileFlag: json['fileFlag'],
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

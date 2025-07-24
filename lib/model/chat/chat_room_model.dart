import 'package:packup/model/common/user_model.dart';

class ChatRoomModel {
  final int? seq;
  final List<int>? partUserSeq;
  final UserModel? user;
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
    this.user,
    this.title,
    this.unReadCount,
    this.lastMessage,
    this.lastMessageDate,
    this.fileFlag,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'partUserSeq': partUserSeq};
  }

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      seq: (json['seq'] as num).toInt(),
      partUserSeq:
          (json['partUserSeq'] as List? ?? [])
              .map((e) => (e as num).toInt())
              .toList(),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      title: json['title'] as String? ?? '',
      unReadCount: (json['unReadCount'] as num?)?.toInt() ?? 0,
      lastMessage: json['lastMessage'] as String?,
      lastMessageDate:
          json['lastMessageDate'] != null && json['lastMessageDate'] != ''
              ? DateTime.parse(json['lastMessageDate'])
              : null,
      fileFlag: json['fileFlag'] as String? ?? 'N',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(), // 또는 null
    );
  }
}

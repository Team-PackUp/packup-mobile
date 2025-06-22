import 'dart:convert';


enum TargetType {
  replyTour(seq: '040001', code: 'REPLY_TOUR', label: '관광'),
  replyGuide(seq: '040002', code: 'REPLY_GUIDE', label: '가이드');

  final String seq;
  final String code;
  final String label;

  const TargetType({required this.seq, required this.code, required this.label});

  static TargetType fromSeq(String seq) =>
      TargetType.values.firstWhere((e) => e.seq == seq);
}

extension TargetTypeX on TargetType {
  String get code => switch (this) {
    TargetType.replyTour  => 'REPLY_TOUR',
    TargetType.replyGuide => 'REPLY_GUIDE',
  };

  String get label => switch (this) {
    TargetType.replyTour  => '관광',
    TargetType.replyGuide => '가이드',
  };
}

extension ReplyMap on ReplyModel {
  Map<String, dynamic> toMap() => {
    'seq'         : seq,
    'targetSeq'   : targetSeq,
    'content'     : content,
    'targetType'  : targetType?.code,
  };
}

class ReplyModel {
  final int? seq;
  final int? userSeq;
  final int? targetSeq;
  final TargetType? targetType;
  final String? content;
  final DateTime? createdAt;

  ReplyModel({
    this.seq,
    this.userSeq,
    this.targetSeq,
    this.targetType,
    this.content,
    this.createdAt,
  });

  String toJson() => jsonEncode({
    'seq'        : seq,
    'userSeq'    : userSeq,
    'target_seq' : targetSeq,
    'target_type': targetType?.code,
    'content'    : content,
    'createdAt'  : createdAt?.toIso8601String(),
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) => ReplyModel(
    seq       : json['seq'],
    userSeq   : json['userSeq'],
    targetSeq : json['targetSeq'],
    targetType: json['targetType'] != null
        ? TargetType.fromSeq(json['targetType'])
        : null,
    content   : json['content'] ?? '',
    createdAt : json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
  );
}

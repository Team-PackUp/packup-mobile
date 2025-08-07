class FileModel {
  final int? seq;
  final String? path;
  final int? userSeq;
  final String? encodedName;
  final String? realName;
  final String? type;
  final DateTime? createdAt;

  FileModel({
    required this.seq,
    required this.path,
    required this.userSeq,
    required this.encodedName,
    required this.realName,
    required this.type,
    required this.createdAt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      seq         : json['seq'],
      path        : json['path'],
      userSeq     : json['userSeq'],
      encodedName : json['encodedName'],
      realName    : json['realName'],
      type        : json['type'],
      createdAt   : json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq'        : seq,
      'path'       : path,
      'userSeq'    : userSeq,
      'encodedName': encodedName,
      'realName'   : realName,
      'type'       : type,
      'createdAt'  : createdAt?.toIso8601String(),
    };
  }
}

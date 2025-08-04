class UserWithDrawLogModel {
  final String reason;
  final String codeName;

  UserWithDrawLogModel({
    required this.reason,
    required this.codeName,
  });

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'codeName': codeName,
    };
  }
}

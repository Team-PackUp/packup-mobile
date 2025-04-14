import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  final String userId;
  final String userAge;
  final String userNation;

  UserModel({
    required this.userId,
    required this.userAge,
    required this.userNation,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'userNumber'  : userId,
      'userAge'     : userAge,
      'userNation'  : userNation,
    };
  }
}
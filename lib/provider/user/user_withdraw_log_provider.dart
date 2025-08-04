import 'package:flutter/material.dart';

import '../../model/user/user_withdraw_log/user_withdraw_log_model.dart';
import '../../service/user/user_withdraw_log_service.dart';

class UserWithDrawLogProvider extends ChangeNotifier {
  final _service = UserWithDrawLogService();

  Future<void> userWithDraw(UserWithDrawLogModel model) async {
    await _service.withDraw(model);
  }
}

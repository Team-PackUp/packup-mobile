import 'package:flutter/material.dart';
import 'package:packup/provider/common/loading_provider.dart';

import '../../model/user/user_withdraw_log/user_withdraw_log_model.dart';
import '../../service/common/loading_service.dart';
import '../../service/user/user_withdraw_log_service.dart';

class UserWithDrawLogProvider extends LoadingProvider {
  final _service = UserWithDrawLogService();

  Future<void> userWithDraw(UserWithDrawLogModel model) async {
    await LoadingService.run(() async {
      await _service.withDraw(model);
    });

    notifyListeners();
  }
}

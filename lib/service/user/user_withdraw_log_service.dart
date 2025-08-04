import 'package:packup/http/dio_service.dart';
import 'package:packup/model/user/register_detail/register_detail_model.dart';
import 'package:packup/model/user/user_withdraw_log/user_withdraw_log_model.dart';

class UserWithDrawLogService {
  static final UserWithDrawLogService _instance = UserWithDrawLogService._internal();

  final DioService _dio = DioService();

  UserWithDrawLogService._internal();

  factory UserWithDrawLogService() {
    return _instance;
  }

  Future<void> withDraw(UserWithDrawLogModel model) async {
    await _dio.postRequest('/user/withdraw', model.toJson());
  }
}

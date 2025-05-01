import 'package:packup/model/common/result_model.dart';
import 'package:packup/model/user/preference/user_preference_model.dart';
import 'package:packup/http/dio_service.dart';

class UserService {
  final DioService _dioService = DioService();

  Future<ResultModel> updateUserPrefer(UserPreferenceModel model) async {
    return await _dioService.putRequest("/user/prefer", model.toJson());
  }
}

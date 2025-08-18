import 'package:image_picker/image_picker.dart';
import 'package:packup/model/user/guide_me_response_model.dart';

import '../../http/dio_service.dart';
import '../../model/common/result_model.dart';
import '../../model/user/profile/user_profile_model.dart';
import '../../model/user/user_withdraw_log/user_withdraw_log_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  final DioService _dio = DioService();

  UserService._internal();

  factory UserService() {
    return _instance;
  }

  Future<ResultModel> updateUserProfileImage(XFile image) async {
    return await DioService().multipartRequest(
      '/user/update/profile-image',
      image,
    );
  }

  Future<ResultModel> updateUserProfile(UserProfileModel model) async {
    return await DioService().putRequest(
      '/user/update/profile',
      model.toJson(),
    );
  }

  Future<ResultModel> updateSettingPush(
    String pushFlg,
    String marketingFLag,
  ) async {
    final data = {'pushFlag': pushFlg, 'marketingFlag': marketingFLag};
    return await DioService().putRequest('/user/update/setting-push', data);
  }

  Future<ResultModel> updateSettingLanguage(
      String languageCode,
      ) async {
    final data = {'languageCode': languageCode};
    return await DioService().putRequest('/user/update/setting-language', data);
  }

  Future<ResultModel> updateSettingNation(
      String nationCode,
      ) async {
    final data = {'nationCode': nationCode};
    return await DioService().putRequest('/user/update/setting-nation', data);
  }

  Future<void> withDraw(UserWithDrawLogModel model) async {
    await _dio.postRequest('/user/withdraw', model.toJson());
  }

  Future<bool> isGuideExists() async {
    final res = await DioService().getRequest('/guide/me/exists');
    return res.response == true;
  }

  Future<GuideMeResponseModel> fetchMyGuide() async {
    final res = await DioService().getRequest('/guide/me');
    return GuideMeResponseModel.fromJson(res.response);
  }
}

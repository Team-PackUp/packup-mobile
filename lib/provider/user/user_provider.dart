import 'package:flutter/material.dart';
import 'package:packup/common/util.dart';
import 'package:packup/const/const.dart';
import 'package:packup/model/common/user_model.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:packup/service/login/login_service.dart';
import 'package:packup/widget/login/social_login_btn.dart';
import 'package:packup/service/login/google_login_service.dart';
import 'package:packup/service/login/kakao_login_service.dart';

import 'package:packup/service/login/social_login.dart';

/// UserModel 구독
class UserProvider with ChangeNotifier {
  late SocialLogin socialLogin;
  UserModel? _userModel;
  ResultModel? _resultModel;
  bool _isLoading = false;
  String? _socialAccessToken = '';
  late bool _isResult;
  bool isInitialized = false;

  String? accessToken = '';
  String? refreshToken = '';

  final LoginService _httpService = LoginService();

  UserModel? get userModel => _userModel;
  ResultModel? get resultModel => _resultModel;
  bool get isLoading => _isLoading;
  String? get socialAccessToken => _socialAccessToken;
  bool get isResult => _isResult;
  bool get hasDetailInfo => _userModel?.isDetailRegistered ?? false;

  // 로그인 시도 (Enum 타입을 직접 사용)
  Future<void> checkLogin(SocialLoginType type) async {
    _isLoading = true;
    bool isResult = false;
    notifyListeners();

    try {
      switch (type) {
        case SocialLoginType.kakao:
          socialLogin = KakaoLogin();
          isResult = await socialLogin.login();
          break;

        case SocialLoginType.google:
          socialLogin = GoogleLogin();
          isResult = await socialLogin.login();
          break;
      }

      if (isResult) {
        final token = await socialLogin.getAccessToken();
        _socialAccessToken = token;

        _resultModel = await _httpService.checkLogin(_socialAccessToken);

        Map<String, dynamic> responseJson = _resultModel?.response;
        accessToken = responseJson[ACCESS_TOKEN];
        refreshToken = responseJson[REFRESH_TOKEN];

        if (accessToken != null) {
          await saveToken(ACCESS_TOKEN, accessToken!);
        }
        if (refreshToken != null) {
          await saveToken(REFRESH_TOKEN, refreshToken!);
        }

        await _httpService.registerFcmToken();

        await getMyInfo();
      }
    } catch (e) {
      logger(e.toString(), 'DEBUG');
    } finally {

      await initLoginStatus();

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initLoginStatus() async {
    accessToken = await getToken(ACCESS_TOKEN);
    refreshToken = await getToken(REFRESH_TOKEN);

    if (accessToken != null && accessToken!.isNotEmpty) {
      await getMyInfo();
    }

    isInitialized = true;
    notifyListeners();
  }

  // 회원정보 조회
  Future<void> getUserInfo(int seq) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {'seq': seq};

      _resultModel = await _httpService.getUserInfo(data);

      if (_resultModel?.statusCode == -1) {
        throw Exception("ERROR ${_resultModel?.message}");
      } else {
        _userModel = _resultModel?.response;
      }
    } catch (e) {
      logger(e.toString(), 'DEBUG');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      await _httpService.logout(); // 먼저 서버에 토큰을 전달 하여 로그아웃 처리

      // await socialLogin.logout();
      await deleteToken(ACCESS_TOKEN);
      await deleteToken(REFRESH_TOKEN);
      _userModel = null;
      accessToken = null;
      refreshToken = null;
      isInitialized = false;

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMyInfo() async {
    _resultModel = await _httpService.getMyInfo();

    if (_resultModel?.statusCode == 200) {
      _userModel = UserModel.fromJson(_resultModel?.response);
      notifyListeners();
    }
  }

  void setProfileImagePath(String path) {
    if (userModel != null) {
      userModel!.profileImagePath = path;
      notifyListeners();
    }
  }
}

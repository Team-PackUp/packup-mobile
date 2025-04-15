import 'package:flutter/material.dart';
import 'package:packup/Common/util.dart';
import 'package:packup/model/common/user_model.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:packup/service/login/login_service.dart';
import 'package:packup/widget/login/social_login_btn.dart';
import 'package:packup/service/login/google_login_service.dart';
import 'package:packup/service/login/kakao_login_service.dart';

import 'package:packup/service/login/social_login.dart';

/// UserModel 구독
class UserViewModel extends ChangeNotifier {

  late SocialLogin socialLogin;
  UserModel? _userModel;
  ResultModel? _resultModel;
  late bool _isLoading;
  String? _accessToken = '';
  late bool _isResult;

  final LoginService _httpService = LoginService();

  UserModel? get userModel      => _userModel;
  ResultModel? get resultModel  => _resultModel;
  bool get isLoading            => _isLoading;
  String? get accessToken       => _accessToken;
  bool get isResult             => _isResult;


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
        _accessToken = token;
      }

    } catch (e) {
      logger(e.toString(), 'DEBUG');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
}

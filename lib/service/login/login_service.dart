
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:packup/http/dio_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:packup/common/util.dart';

class LoginService {

  static final LoginService _instance = LoginService._internal();

  // 객체 생성 방지
  LoginService._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory LoginService() {
    return _instance;
  }

  Future<ResultModel> checkLogin(accessToken) async {
    final data = {'access_token' : accessToken};
    return await DioService().postRequest('/auth/login/google', data);
  }

  Future<ResultModel> logout() async {
    return await DioService().deleteRequest('/auth/logout');
  }

  Future<ResultModel> getUserInfo(Map<String, dynamic> data) async {
    return await DioService().getRequest('get_user_info', data);
  }
  
  Future<ResultModel> getMyInfo() async {
    return await DioService().getRequest('/user/me');
  }

  Future<void> registerFcmToken() async {
    final fcmTokenKey = dotenv.env['FCM_TOKEN_KEY']!;
    final osType = Platform.isIOS ? 'IOS' : 'ANDROID';
    
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    print('fcmToken');
    print(fcmToken);

    if (fcmToken != null) {
      await saveToken(fcmTokenKey, fcmToken);
      await DioService().postRequest('/fcm/register', {
        'fcmToken': fcmToken,
        'osType': osType
      });
    }
  }

}
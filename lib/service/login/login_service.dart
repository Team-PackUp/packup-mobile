
import 'package:packup/model/common/result_model.dart';
import 'package:packup/http/dio_service.dart';

class LoginService {

  static final LoginService _instance = LoginService._internal();

  // 객체 생성 방지
  LoginService._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory LoginService() {
    return _instance;
  }

  Future<ResultModel> checkLogin(loginModel) async {
    String url = '/user/login_check';

    return await DioService().postRequest(url, loginModel);
  }

  Future<ResultModel> getUserInfo(Map<String, dynamic> data) async {
    String url = '/user/get_user_info';

    return await DioService().getRequest(url, data);
  }
}
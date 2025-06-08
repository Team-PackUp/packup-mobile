import 'package:packup/http/dio_service.dart';
import 'package:packup/model/user/register_detail/register_detail_model.dart';

class RegisterDetailService {
  final DioService _dio = DioService();

  Future<void> submitUserDetail(RegisterDetailModel detail) async {
    await _dio.putRequest('/user/detail', detail.toJson());
  }
}

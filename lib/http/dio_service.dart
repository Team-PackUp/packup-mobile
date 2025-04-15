import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:packup/model/common/result_model.dart';
import 'interceptor.dart';

class DioService {
  static final DioService _instance = DioService._internal();

  factory DioService() => _instance;

  late Dio dio;

  DioService._internal() {
    dio = Dio(BaseOptions(
      baseUrl: dotenv.env['HTTP_URL']!,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: 'Bearer ${await getToken()}'
      },
    ))
      ..interceptors.add(CustomInterceptor());
  }

  Future<ResultModel> postRequest(String url, dynamic data) async {
    final response = await dio.post(
      url,
      data: data != null ? json.encode(data) : null,
    );
    return ResultModel.fromJson(response.data);
  }

  Future<ResultModel> getRequest(String url, Map<String, dynamic> data) async {
    final response = await dio.get(url, queryParameters: data);
    return ResultModel.fromJson(response.data);
  }
}

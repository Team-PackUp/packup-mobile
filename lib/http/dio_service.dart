import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:packup/model/common/result_model.dart';
import 'interceptor.dart';

class DioService {
  static final DioService _instance = DioService._internal();

  factory DioService() => _instance;

  late Dio dio;

  String httpPrefix = dotenv.env['HTTP_URL']!;

  DioService._internal() {
    dio = Dio(BaseOptions(
      baseUrl: httpPrefix,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        // HttpHeaders.authorizationHeader: 'Bearer ${await getToken()}'
      },
    ))
      ..interceptors.add(CustomInterceptor());
  }

  Future<ResultModel> postRequest(String uri, [Map<String, dynamic>? data]) async {

    String url = httpPrefix + uri;
    final response = await dio.post(
      url,
      data: data ?? {},
    );
    return ResultModel.fromJson(response.data);
  }

  Future<ResultModel> getRequest(String uri, [Map<String, dynamic>? data]) async {
    String url = httpPrefix + uri;

    final response = await dio.get(
      url,
      queryParameters: data ?? {},
    );

    return ResultModel.fromJson(response.data);
  }

  Future<ResultModel> putRequest(String uri, [Map<String, dynamic>? data]) async {
    String url = httpPrefix + uri;

    final response = await dio.put(
      url,
      data: data ?? {},
    );

    return ResultModel.fromJson(response.data);
  }

  Future<ResultModel> deleteRequest(String uri, [Map<String, dynamic>? data]) async {
    String url = httpPrefix + uri;

    final response = await dio.delete(
      url,
      data: data ?? {},
    );

    return ResultModel.fromJson(response.data);
  }


}

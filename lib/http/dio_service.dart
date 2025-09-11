import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import 'package:packup/model/common/result_model.dart';

import 'package:packup/common/util.dart';
import 'package:path/path.dart' as p;
import 'interceptor.dart';

class DioService {
  static final DioService _instance = DioService._internal();

  factory DioService() => _instance;

  late Dio dio;

  String httpPrefix = dotenv.env['HTTP_URL']!;
  String accessTokenKey = dotenv.env['ACCESS_TOKEN_KEY']!;

  DioService._internal() {
    dio =
        Dio(
            BaseOptions(
              baseUrl: httpPrefix,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ),
          )
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) async {
                final token = await getToken(accessTokenKey);
                options.headers[HttpHeaders.authorizationHeader] =
                    'Bearer $token';
                return handler.next(options);
              },
            ),
          )
          ..interceptors.add(CustomInterceptor());
  }

  Future<ResultModel> postRequest(
    String uri, [
    Map<String, dynamic>? data,
  ]) async {
    String url = httpPrefix + uri;
    final response = await dio.post(url, data: data ?? {});
    return ResultModel.fromJson(response.data);
  }

  Future<ResultModel> getRequest(
    String uri, [
    Map<String, dynamic>? data,
  ]) async {
    String url = httpPrefix + uri;

    final response = await dio.get(url, queryParameters: data ?? {});

    return ResultModel.fromJson(response.data);
  }

  Future<ResultModel> multipartRequest(String uri, XFile file) async {
    String url = httpPrefix + uri;
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await dio.post(url, data: formData);
    return ResultModel.fromJson(response.data);
  }


  Future<ResultModel> multipartListRequest(String uri, List<XFile> files) async {
    final url = httpPrefix + uri;

    final fileParts = await Future.wait(files.map((xf) async =>
    await MultipartFile.fromFile(xf.path, filename: p.basename(xf.path))
    ));

    final formData = FormData.fromMap({
      'file': fileParts,
    });

    final res = await dio.post(url, data: formData);
    return ResultModel.fromJson(res.data);
  }



  Future<ResultModel> multipartRequestWithFields(
    String uri,
    XFile file, {
    required String fileFieldName,
    required Map<String, String> extraFields,
  }) async {
    final url = httpPrefix + uri;
    final fileName =
        file.name.isNotEmpty ? file.name : file.path.split('/').last;

    final formMap = <String, dynamic>{
      fileFieldName: await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      ...extraFields,
    };

    final formData = FormData.fromMap(formMap);
    final response = await dio.post(url, data: formData);
    return ResultModel.fromJson(response.data);
  }

  Future<ResultModel> putRequest(
    String uri, [
    Map<String, dynamic>? data,
  ]) async {
    String url = httpPrefix + uri;

    final response = await dio.put(url, data: data ?? {});

    return ResultModel.fromJson(response.data);
  }

  Future<ResultModel> deleteRequest(
    String uri, [
    Map<String, dynamic>? data,
  ]) async {
    String url = httpPrefix + uri;

    final response = await dio.delete(url, data: data ?? {});

    return ResultModel.fromJson(response.data);
  }
}

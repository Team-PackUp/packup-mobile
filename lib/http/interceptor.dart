import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:packup/common/util.dart';
import 'package:packup/const/const.dart';
import 'package:packup/const/const.dart';

import 'api_exception.dart';

class CustomInterceptor extends Interceptor {
  String httpPrefix = dotenv.env['HTTP_URL']!;
  String refreshTokenKey = dotenv.env['REFRESH_TOKEN_KEY']!;
  String accessTokenKey = dotenv.env['ACCESS_TOKEN_KEY']!;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    logger('[REQ] [${options.method}] ${options.uri}');

    final accessToken = await getToken(ACCESS_TOKEN);

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers.addAll({'Authorization': 'Bearer $accessToken'});
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger(
      '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}',
    );

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    logger(
      '[REQ] [${err.requestOptions.method}] ${err.requestOptions.uri}',
      ERROR,
    );

    final refreshToken = await getToken(REFRESH_TOKEN);

    if (refreshToken == null) {
      return handler.reject(err);
    }

    switch (err.type) {
      case DioExceptionType.cancel:
        logger('[REQ] [API 호출 취소]', ERROR);
        break;
      case DioExceptionType.receiveTimeout:
        logger('[REQ] [API 연결 시간 초과]', ERROR);
        break;
      case DioExceptionType.unknown:
        logger('[REQ] [API 수신 시간 초과]', ERROR);
        break;
      case DioExceptionType.sendTimeout:
        logger('[REQ] [API 요청 시간 초과]', ERROR);
        break;
      default:
        logger('[REQ] [API 기타 에러 발생]', ERROR);
        break;
    }

    final statusCode = err.response?.statusCode;
    if (statusCode == null) {
      return handler.reject(err);
    }

    switch (statusCode) {
      case 401:
        final isPathRefresh = err.requestOptions.path == '/api/auth/refresh';

        if (!isPathRefresh) {
          final dio = Dio(
            BaseOptions(
              baseUrl: httpPrefix,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

          try {
            final res = await dio.post(
              '$httpPrefix/auth/refresh',
              data: {'refreshToken': refreshToken},
            );

            final newAccessToken = res.data['response']['accessToken'];
            await saveToken(ACCESS_TOKEN, newAccessToken);

            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryResponse = await dio.fetch(options);
            return handler.resolve(retryResponse);
          } on DioException catch (e) {
            // await storage.deleteAll();
            // Get.key.currentContext?.go('/');

            return handler.reject(e);
          }
        }
        break;
      case 404:
        logger('[REQ] [API 404 오류]', ERROR);
        break;
      case 500:
        logger('[REQ] [API 오류]', ERROR);
        break;
      default:
        logger('[REQ] [API 기타 서버 오류]', ERROR);
        break;
    }

    final data = err.response?.data;
    String? msg;
    String? code;
    int? status;

    if (data is Map) {
      msg = (data['message'] as String?)?.trim();
      code = data['code'] as String?;
      status = err.response?.statusCode ?? (data['status'] as int?);
    } else if (data is String && data.trim().isNotEmpty) {
      msg = data.trim();
      status = err.response?.statusCode;
    }

    msg ??= _fallbackMessage(status ?? err.response?.statusCode);

    return handler.reject(err.copyWith(
      error: ApiException(msg, status: status ?? err.response?.statusCode, code: code),
    ));
  }
  }

String _fallbackMessage(int? status) {
  switch (status) {
    case 400: return '잘못된 요청입니다.';
    case 401: return '로그인이 필요합니다.';
    case 403: return '접근 권한이 없습니다.';
    case 404: return '요청한 자원을 찾을 수 없습니다.';
    case 409: return '요청이 충돌했습니다.';
    case 422: return '입력값을 확인해주세요.';
    case 500: return '서버 오류가 발생했습니다.';
    default:  return '요청 처리 중 오류가 발생했습니다.';
  }
}

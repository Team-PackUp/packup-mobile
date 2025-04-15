import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:packup/common/util.dart';
import 'package:packup/const/const.dart';

class CustomInterceptor extends Interceptor {

  String httpPrefix = dotenv.env['HTTP_URL']!;
  String refreshTokenKey = dotenv.env['REFRESH_TOKEN_KEY']!;
  String accessTokenKey = dotenv.env['ACCESS_TOKEN_KEY']!;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger('[REQ] [${options.method}] ${options.uri}');

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger('[REQ] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {

    logger('[REQ] [${err.requestOptions.method}] ${err.requestOptions.uri}', ERROR);

    final refreshToken = await storage.read(key: refreshTokenKey);

    // refreshToken 이 없으면 > throw exception
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
      case 401: // 401 에러인 경우 > 토큰 재발행
        final isPathRefresh = err.requestOptions.path == '/auth/token';
        // 요청 URL이 토큰이 아닌 경우
        if (!isPathRefresh) {

          final dio = Dio(BaseOptions(
            baseUrl: httpPrefix,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ));


          try {
            final res = await dio.post(
              '$httpPrefix/auth/token',
              options: Options(headers: {
                'authorization': 'Bearer $refreshToken',
              }),
            );
            final accessToken = res.data['accessToken'];

            final options = err.requestOptions;

            // 토큰 변경
            options.headers.addAll({
              'authorization': 'Bearer $accessToken',
            });

            await storage.write(key: accessTokenKey, value: accessToken);

            // 요청 재전송
            final response = await dio.fetch(options);

            return handler.resolve(response);
          } on DioException catch (e) {
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

    return handler.reject(err);
  }
}
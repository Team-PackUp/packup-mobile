import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:packup/widget/common/util_widget.dart';

class CustomErrorHandler {
  static void run(BuildContext context, Object e) {
    String msg = '서버에 오류가 발생했습니다';

    if (e is DioException) {
      msg = _parseDioException(e);
    } else if (e is SocketException) {
      msg = '네트워크 연결이 불안정합니다.';
    } else if (e is TimeoutException) {
      msg = '요청 시간이 초과되었습니다.';
    } else if (e is String) {
      msg = e;
    } else if (e is Error || e is Exception) {
      msg = e.toString().replaceAll('Exception: ', '');
    }

    CustomSnackBar.showError(context, msg);
  }

  static String _parseDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final path = e.requestOptions.path;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '서버 연결이 지연되고 있습니다.';
      case DioExceptionType.sendTimeout:
        return '요청이 서버에 도달하지 못했습니다.';
      case DioExceptionType.receiveTimeout:
        return '서버 응답이 지연되고 있습니다.';
      case DioExceptionType.badResponse:
        return e.response?.data['message'] ??
            '오류가 발생했습니다 (${statusCode ?? 'Unknown'})';
      case DioExceptionType.cancel:
        return '요청이 취소되었습니다.';
      case DioExceptionType.unknown:
      default:
        return '예상치 못한 오류가 발생했습니다: ${e.message}';
    }
  }
}

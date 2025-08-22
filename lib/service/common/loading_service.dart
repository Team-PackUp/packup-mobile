import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../../http/api_exception.dart';
import '../../provider/common/loading_provider.dart';
import '../../widget/common/util_widget.dart';

class LoadingService {
  static late LoadingProvider notifier;

  static final LoadingService _instance = LoadingService._internal();
  factory LoadingService() => _instance;
  LoadingService._internal();

  static Future<T> run<T>(Future<T> Function() cb) async {
    return notifier.handleLoading(cb);
  }

  /// 공통 에러 처리 포함: 성공 true, 실패 false
  static Future<bool> runHandled(
      BuildContext? context,
      Future<void> Function() cb, {
        String? successMessage,
      }) async {
    try {
      await notifier.handleLoading(cb);

      if (context != null && successMessage?.isNotEmpty == true) {
        CustomSnackBar.showResult(context, successMessage!);
      }

      return true;
    } on ApiException catch (e) {
      if (context != null) CustomSnackBar.showError(context, e.message);
      return false;
    } on DioException catch (e) {
      final inner = e.error;
      if (inner is ApiException) {
        if (context != null) CustomSnackBar.showError(context, inner.message);
      } else {
        if (context != null) CustomSnackBar.showError(context, '네트워크 오류가 발생했습니다.');
      }
      return false;
    } catch (_) {
      if (context != null) CustomSnackBar.showError(context, '알 수 없는 오류가 발생했습니다.');
      return false;
    }
  }

}

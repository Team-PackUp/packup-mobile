import 'package:packup/http/dio_service.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';

class TossPaymentService {
  Future<ResultModel> confirmPayment({
    required String paymentKey,
    required String orderId,
    required int amount,
  }) async {
    final data = {
      'paymentKey': paymentKey,
      'orderId': orderId,
      'amount': amount,
    };
    return await DioService().postRequest('/payment/confirm', data);
  }
}

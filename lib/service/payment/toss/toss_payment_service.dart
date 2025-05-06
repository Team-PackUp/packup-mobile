// lib/service/payment/toss/toss_payment_service.dart

import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';

class TossPaymentService {
  final PaymentWidget paymentWidget;

  TossPaymentService(this.paymentWidget);

  /// 결제 요청을 수행하고 결과를 반환
  Future<Result> requestPayment({
    required PaymentInfo paymentInfo,
  }) async {
    try {
      return await paymentWidget.requestPayment(paymentInfo: paymentInfo);
    } catch (e) {
      print("결제 요청 실패: $e");
      rethrow;
    }
  }
}

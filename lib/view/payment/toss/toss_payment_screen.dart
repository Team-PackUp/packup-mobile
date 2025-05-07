import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:tosspayments_widget_sdk_flutter/model/paymentData.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';
import 'package:tosspayments_widget_sdk_flutter/pages/tosspayments_sdk_flutter.dart';

/// 결제 위젯 화면
/// Toss SDK를 이용해 실제 결제를 수행하는 화면입니다.
///
/// [Get.arguments]를 통해 PaymentData 를 받아 처리합니다.
/// 성공하거나 실패하면 해당 결과를 Get.back 으로 되돌려줍니다.
class TossPaymentScreen extends StatelessWidget {
  const TossPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PaymentData data = Get.arguments as PaymentData;

    return TossPayments(
      clientKey: dotenv.env['TOSS_CLIENT_KEY']!,
      data: data,
      success: (Success success) {
        Get.back(result: success);
      },
      fail: (Fail fail) {
        Get.back(result: fail);
      },
    );
  }
}

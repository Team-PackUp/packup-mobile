// lib/provider/payment/toss/toss_payment_provider.dart

import 'package:flutter/material.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:packup/model/payment/toss/toss_payment_info_mode.dart';
import 'package:packup/service/payment/toss/toss_payment_service.dart';

/// 결제 상태를 관리하는 Provider (MVVM ViewModel 역할)
class TossPaymentProvider with ChangeNotifier {
  TossPaymentInfo? _paymentInfo;
  bool _isProcessing = false;

  TossPaymentInfo? get paymentInfo => _paymentInfo;
  bool get isProcessing => _isProcessing;

  final TossPaymentService _httpService = TossPaymentService();

  Future<ResultModel?> confirmPayment({
    required String paymentKey,
    required String orderId,
    required int amount,
  }) async {
    try {
      startProcessing();
      return await _httpService.confirmPayment(
        paymentKey: paymentKey,
        orderId: orderId,
        amount: amount,
      );
    } catch (e) {
      debugPrint('결제 확인 실패: $e');
      return null;
    } finally {
      endProcessing();
    }
  }

  /// 결제 정보 초기화
  void setPaymentInfo(TossPaymentInfo info) {
    _paymentInfo = info;
    notifyListeners();
  }

  /// 결제 시작
  void startProcessing() {
    _isProcessing = true;
    notifyListeners();
  }

  /// 결제 종료
  void endProcessing() {
    _isProcessing = false;
    notifyListeners();
  }

  /// 전체 초기화
  void reset() {
    _paymentInfo = null;
    _isProcessing = false;
    notifyListeners();
  }
}

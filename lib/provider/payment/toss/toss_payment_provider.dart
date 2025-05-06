// lib/provider/payment/toss/toss_payment_provider.dart

import 'package:flutter/material.dart';
import 'package:packup/model/payment/toss/toss_payment_info_mode.dart';

/// 결제 상태를 관리하는 Provider (MVVM ViewModel 역할)
class TossPaymentProvider with ChangeNotifier {
  TossPaymentInfo? _paymentInfo;
  bool _isProcessing = false;

  TossPaymentInfo? get paymentInfo => _paymentInfo;
  bool get isProcessing => _isProcessing;

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

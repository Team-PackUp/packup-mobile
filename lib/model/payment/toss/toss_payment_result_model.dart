class TossPaymentSuccess {
  final String paymentKey;
  final String orderId;
  final int amount;

  TossPaymentSuccess({
    required this.paymentKey,
    required this.orderId,
    required this.amount,
  });
}

class TossPaymentFailure {
  final String code;
  final String message;

  TossPaymentFailure({
    required this.code,
    required this.message,
  });
}

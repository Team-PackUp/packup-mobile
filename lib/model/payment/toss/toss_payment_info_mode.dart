class TossPaymentInfo {
  final String method;
  final String orderId;
  final String orderName;
  final int amount;
  final String customerName;
  final String customerEmail;

  TossPaymentInfo({
    required this.method,
    required this.orderId,
    required this.orderName,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
  });

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'orderId': orderId,
      'orderName': orderName,
      'amount': amount,
      'customerName': customerName,
      'customerEmail': customerEmail,
    };
  }
}

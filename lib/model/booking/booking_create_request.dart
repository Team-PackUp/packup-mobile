class BookingCreateRequest {
  final int tourSessionSeq;
  final int adultCount;
  final bool privateFlag;
  final String orderId;
  final String paymentKey;
  final int amount;

  const BookingCreateRequest({
    required this.tourSessionSeq,
    required this.adultCount,
    required this.privateFlag,
    required this.orderId,
    required this.paymentKey,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    "tourSessionSeq": tourSessionSeq,
    "bookingAdultCount": adultCount,
    "bookingKidsCount": 0,
    "bookingPrivateFlag": privateFlag ? "Y" : "N",
    "orderId": orderId,
    "paymentKey": paymentKey,
    "amount": amount,
  };
}

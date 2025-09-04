enum TourSessionStatusCode {
  open(110001, '모집중'),
  full(110002, '정원 초과'),
  completed(110003, '종료'),
  canceled(110004, '취소');

  final int code;
  final String label;
  const TourSessionStatusCode(this.code, this.label);

  static TourSessionStatusCode from(int code) =>
      TourSessionStatusCode.values.firstWhere(
        (e) => e.code == code,
        orElse: () => TourSessionStatusCode.canceled,
      );

  bool get isReservable => this == TourSessionStatusCode.open;
  bool get isVisibleOnList =>
      this == TourSessionStatusCode.open || this == TourSessionStatusCode.full;
}

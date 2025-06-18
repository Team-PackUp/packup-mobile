enum TourStatusCode {
  temp,
  recruiting,
  recruited,
  ready,
  ongoing,
  finished,
}

extension TourStatusCodeExtension on TourStatusCode {
  String get code {
    switch (this) {
      case TourStatusCode.temp:
        return '100001';
      case TourStatusCode.recruiting:
        return '100002';
      case TourStatusCode.recruited:
        return '100003';
      case TourStatusCode.ready:
        return '100004';
      case TourStatusCode.ongoing:
        return '100005';
      case TourStatusCode.finished:
        return '100006';
    }
  }

  String get label {
    switch (this) {
      case TourStatusCode.temp:
        return '임시저장';
      case TourStatusCode.recruiting:
        return '모집중';
      case TourStatusCode.recruited:
        return '모집완료';
      case TourStatusCode.ready:
        return '출발대기';
      case TourStatusCode.ongoing:
        return '투어중';
      case TourStatusCode.finished:
        return '종료';
    }
  }

  static TourStatusCode fromEnumName(String name) {
    return TourStatusCode.values.firstWhere(
          (e) => e.name.toUpperCase() == name.toUpperCase(),
      orElse: () => throw ArgumentError('Unknown name: $name'),
    );
  }

}

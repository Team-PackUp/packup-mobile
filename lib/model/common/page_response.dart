class PageResponse<T> {
  final List<T> content;
  final int totalElements;
  final int totalPages;
  final int number; // 현재 페이지 번호
  final bool last;
  final bool first;
  final int size;
  final int numberOfElements;
  final bool empty;

  PageResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.number,
    required this.last,
    required this.first,
    required this.size,
    required this.numberOfElements,
    required this.empty,
  });

  factory PageResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return PageResponse<T>(
      content: (json['content'] as List).map(fromJsonT).toList(),
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      number: json['number'],
      last: json['last'],
      first: json['first'],
      size: json['size'],
      numberOfElements: json['numberOfElements'],
      empty: json['empty'],
    );
  }
}

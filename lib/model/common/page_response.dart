class PageResponse<T> {
  final List<T> content;
  final int page;               // 사용자에게 보여줄 1-based 페이지 번호
  final int number;             // 내부에서 사용하는 0-based 번호
  final int size;
  final int totalElements;
  final int totalPages;
  final bool last;
  final bool first;
  final bool empty;

  PageResponse({
    required this.content,
    required this.page,
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.first,
    required this.empty,
  });

  factory PageResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic) fromJsonT,
      ) {
    return PageResponse<T>(
      content: (json['content'] as List).map(fromJsonT).toList(),
      page: json['page'],                   // 1-based
      number: json['number'],               // 0-based
      size: json['size'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      last: json['last'],
      first: json['first'],
      empty: json['empty'],
    );
  }
}

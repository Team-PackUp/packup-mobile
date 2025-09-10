class PageModel<T> {
  final List<T> objectList;
  final int totalPage;
  final int totalElement;
  final int curPage;
  final bool nextPageFlag;

  PageModel({
    required this.objectList,
    required this.totalPage,
    required this.totalElement,
    required this.curPage,
    required this.nextPageFlag,
  });

  factory PageModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) convert,
  ) {
    final list =
        (json['objectList'] as List? ?? [])
            .map((e) => convert(e as Map<String, dynamic>))
            .toList();

    return PageModel<T>(
      objectList: list,
      totalPage: json['totalPage'] ?? 0,
      totalElement: json['totalElement'] ?? 0,
      curPage: json['curPage'] ?? 0,
      nextPageFlag:
          json['nextPageFlag'] is bool
              ? json['nextPageFlag'] as bool
              : (json['nextPageFlag'] == 1 || json['nextPageFlag'] == '1'),
    );
  }
}

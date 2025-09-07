class PageModel<T> {
  final List<T> objectList;
  final int totalPage;
  final int totalElements;
  final int curPage;
  final bool nextPageFlag;

  PageModel({
    required this.objectList,
    required this.totalPage,
    required this.totalElements,
    required this.curPage,
    required this.nextPageFlag,
  });

  factory PageModel.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) convert,
      ) {
    final list = (json['objectList'] as List? ?? [])
        .map((e) => convert(e as Map<String, dynamic>))
        .toList();

    return PageModel<T>(
      objectList: list,
      totalPage: json['totalPage'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      curPage: json['curPage'] ?? 0,
      nextPageFlag: json['nextPageFlag'] ?? 0,
    );
  }
}

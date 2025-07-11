class PageModel {
  final List<dynamic> objectList;
  final int totalPage;
  final int totalElements;
  final int curPage;

  PageModel({
    required this.objectList,
    required this.totalPage,
    required this.totalElements,
    required this.curPage,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      objectList     : json['objectList'],
      totalPage      : json['totalPage'],
      totalElements  : json['totalElements'] ?? 0,
      curPage        : json['curPage'],
    );
  }
}
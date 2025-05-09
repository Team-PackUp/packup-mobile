class PageModel {
  final List<dynamic> objectList;
  final int totalPage;

  PageModel({
    required this.objectList,
    required this.totalPage,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      objectList         : json['objectList'],
      totalPage        : json['totalPage'],
    );
  }
}
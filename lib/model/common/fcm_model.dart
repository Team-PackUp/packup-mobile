class FcmModel {
  final String title;
  final String body;

  FcmModel({
    required this.title,
    required this.body,
  });
}

extension FcmMap on FcmModel {
  Map<String, dynamic> toMap() => {
    'title'         : title,
    'body'   : body,
  };
}
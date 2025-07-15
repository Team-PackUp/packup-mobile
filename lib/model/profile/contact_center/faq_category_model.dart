class FaqCategoryModel {
  final String? codeId;
  final String? codeName;

  FaqCategoryModel({
    this.codeId,
    this.codeName,
  });

  factory FaqCategoryModel.fromJson(Map<String, dynamic> json) {
    return FaqCategoryModel(
      codeId: json['codeId'],
      codeName: json['codeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codeId': codeId,
      'codeName': codeName,
    };
  }
}

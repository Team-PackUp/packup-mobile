class CodeMappingModel {
  final String code;
  final String label;

  CodeMappingModel({required this.code, required this.label});

  factory CodeMappingModel.fromJson(Map<String, dynamic> json) {
    return CodeMappingModel(
      code: json['code'],
      label: json['label'],
    );
  }
}

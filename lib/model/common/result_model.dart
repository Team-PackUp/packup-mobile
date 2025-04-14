class ResultModel {
  final String message;
  final bool resultFlag;
  final int statusCode;
  final dynamic response;

  ResultModel({
    required this.message,
    required this.resultFlag,
    required this.statusCode,
    required this.response,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      message     : json['message'],
      resultFlag  : json['resultFlag'],
      statusCode  : json['statusCode'],
      response    : json['response'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message'     : message,
      'resultFlag'  : resultFlag,
      'statusCode'  : statusCode,
      'response'    : response,
    };
  }
}
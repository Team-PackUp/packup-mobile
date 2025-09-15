class PresignRequest {
  final String filename;
  final String contentType;
  final String? prefix;

  PresignRequest({
    required this.filename,
    required this.contentType,
    this.prefix,
  });

  Map<String, dynamic> toJson() => {
    "filename": filename,
    "contentType": contentType,
    if (prefix != null) "prefix": prefix,
  };
}

class PresignResponse {
  final String uploadUrl;
  final String key;
  final Map<String, String> headers;

  PresignResponse({
    required this.uploadUrl,
    required this.key,
    required this.headers,
  });

  factory PresignResponse.fromJson(Map<String, dynamic> json) {
    final rawHeaders = (json["headers"] ?? {}) as Map;
    return PresignResponse(
      uploadUrl: json["uploadUrl"] as String,
      key: json["key"] as String,
      headers: rawHeaders.map(
        (k, v) => MapEntry(k.toString(), v?.toString() ?? ""),
      ),
    );
  }
}

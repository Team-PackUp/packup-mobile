import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/model/common/presigned_model.dart';
import 'package:path/path.dart' as p;

import 'package:packup/http/dio_service.dart';
import 'package:packup/model/common/result_model.dart';

class S3UploadService {
  Future<PresignResponse> presign({
    required String filename,
    required String contentType,
    String? prefix,
  }) async {
    final body =
        PresignRequest(
          filename: filename,
          contentType: contentType,
          prefix: prefix,
        ).toJson();

    final ResultModel res = await DioService().postRequest(
      '/files/presign',
      body,
    );

    final dynamic payload = res.response;
    if (payload is Map<String, dynamic>) {
      return PresignResponse.fromJson(payload);
    }
    throw StateError('Invalid presign response payload: $payload');
  }

  Future<void> putObject({
    required String uploadUrl,
    required Uint8List bytes,
    Map<String, String>? headers,
    void Function(double progress)? onProgress,
  }) async {
    final dio = Dio(
      BaseOptions(
        followRedirects: true,
        validateStatus: (status) => (status ?? 0) < 400,
      ),
    );

    final Map<String, dynamic> hdrs = {
      if (headers != null) ...headers,
      'Content-Length': bytes.length,
      if (headers == null || !headers.containsKey('Content-Type'))
        'Content-Type':
            _guessContentTypeByExt(uploadUrl) ?? 'application/octet-stream',
    };

    await dio.put(
      uploadUrl,
      data: Stream.fromIterable(<List<int>>[bytes]),
      options: Options(headers: hdrs),
      onSendProgress: (sent, total) {
        if (onProgress != null && total > 0) {
          onProgress(sent / total);
        }
      },
    );
  }

  Future<String> uploadXFileAndReturnKey(
    XFile pickedFile, {
    String? prefix,
    String? contentType,
    void Function(double progress)? onProgress,
  }) async {
    final filename = p.basename(pickedFile.path);
    final bytes = await pickedFile.readAsBytes();
    final ct =
        contentType ??
        _guessContentTypeByExt(filename) ??
        'application/octet-stream';

    final presigned = await presign(
      filename: filename,
      contentType: ct,
      prefix: prefix,
    );

    await putObject(
      uploadUrl: presigned.uploadUrl,
      bytes: bytes,
      headers: presigned.headers,
      onProgress: onProgress,
    );

    return presigned.key;
  }

  Future<List<String>> uploadXFilesAndReturnKeys(
    List<XFile> files, {
    String? prefix,
    void Function(int index, double progress)? onProgress,
  }) async {
    final keys = <String>[];
    for (int i = 0; i < files.length; i++) {
      final key = await uploadXFileAndReturnKey(
        files[i],
        prefix: prefix,
        onProgress: (p) => onProgress?.call(i, p),
      );
      keys.add(key);
    }
    return keys;
  }

  String? _guessContentTypeByExt(String pathOrName) {
    final ext = p.extension(pathOrName).toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      default:
        return null;
    }
  }

  Future<List<String>> viewUrlsForKeys(
    List<String> keys, {
    int ttlMinutes = 60,
  }) async {
    final cdn = dotenv.env['CDN_BASE_URL'];
    if (cdn != null && cdn.isNotEmpty) {
      return keys.map((k) {
        if (k.startsWith('http')) return k;
        return '$cdn$k';
      }).toList();
    }

    final res = await DioService().postRequest('/files/view-urls', {
      'keys': keys,
      'ttlMinutes': ttlMinutes,
    });

    final payload =
        (res.response is Map)
            ? Map<String, dynamic>.from(res.response as Map)
            : const {};
    // 서버는 {key: url, ...} 맵을 돌려줌
    return keys.map((k) => payload[k]?.toString() ?? '').toList();
  }
}

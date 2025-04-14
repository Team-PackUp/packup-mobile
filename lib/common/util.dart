import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const storage = FlutterSecureStorage();

/// ################### Shared preference ################### ///
// 테마 조회
Future<String> getSystemTheme() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getString('theme') ?? "light";
}

// 테마 저장
Future<bool> saveSystemTheme(String theme) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setString('theme', theme);
}

/// ################### Secure Storage ################### ///

// 토큰 저장
Future<void> saveToken(String key, String token) async {
  return await storage.write(key: key, value: token);
}

// 토큰 조회
Future<String?> getToken(String key) async {
  String? token = await storage.read(key: key);
  return token;
}

// 토큰 삭제
Future<void> deleteToken(String key) async {
  return await storage.delete(key: key);
}

/// ################### DATE ################### ///

DateTime getToday() {

  // 오늘 날짜
  DateTime nowDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  String formattedNowDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(nowDate);
  return nowDate;
}

/// ################### LOGGER ################### ///
logger(String message, [String type = "TRACE"]) {
  final logger = Logger();

  switch(type) {
    case "TRACE" :
      logger.t('$type $message');
      break;
    case "DEBUG" :
      logger.d('$type $message');
      break;
    case "INFO" :
      logger.i('$type $message');
      break;
    case "ERROR" :
      logger.e('$type $message');
      break;
  }
}


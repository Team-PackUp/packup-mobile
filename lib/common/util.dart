import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/const.dart';

const storage = FlutterSecureStorage();
final httpPrefix = dotenv.env['HTTP_URL']!;

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

Future<int> decodeTokenInfo() async {
  final token = await getToken(ACCESS_TOKEN);
  if (token == null) throw Exception("토큰을 찾을 수 없음");

  final parts = token.split('.');
  if (parts.length != 3) throw Exception("토큰 정보 이상");

  final payload = parts[1];
  final normalized = base64.normalize(payload);
  final decoded = utf8.decode(base64Url.decode(normalized));
  final Map<String, dynamic> payloadMap = jsonDecode(decoded);

  return int.parse(payloadMap['sub']);
}

String formatAmount(int amount) {
  final format = NumberFormat.decimalPattern(); // ex: 1,000,000
  return format.format(amount);
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

String convertToYmd(DateTime date, [String format = 'yyyy-MM-dd']) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String convertToHm(DateTime date, [String format = 'HH:mm']) {
  return DateFormat(format).format(date);
}

int getDateDiffInDays(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(dateTime.year, dateTime.month, dateTime.day);

  return today.difference(target).inDays;
}

// 어제 이전, 어제, 오늘 체크
enum DateType { today, yesterday, before }

DateType getDateType(DateTime target) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final targetDate = DateTime(target.year, target.month, target.day);

  if (targetDate == today) {
    return DateType.today;
  } else if (targetDate == yesterday) {
    return DateType.yesterday;
  } else {
    return DateType.before;
  }
}

// 며칠전 등록 글인지, 금일이면 몇 분 전인지
String getTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (now.year == dateTime.year &&
      now.month == dateTime.month &&
      now.day == dateTime.day) {
    // 오늘
    if (diff.inMinutes < 1) {
      return '방금 전';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else {
      return '${diff.inHours}시간 전';
    }
  } else {
    // 오늘 이전
    return '${diff.inDays}일 전';
  }
}

String getMonthYear(DateTime dateTime) {
  final formatter = DateFormat('MMMM yyyy', 'en_US');
  return formatter.format(dateTime);
}

String getDayMonthYear(DateTime dateTime) {
  final formatter = DateFormat('MMMM dd, yyyy', 'en_US');
  return formatter.format(dateTime);
}

/// ################### FILE ################### ///
String fullFileUrl(String path) {
  return '$httpPrefix$path';
}

/// ################### LOGGER ################### ///
logger(dynamic message, [String type = "TRACE"]) {
  final logger = Logger();

  switch (type) {
    case "TRACE":
      logger.t('$type $message');
      break;
    case "DEBUG":
      logger.d('$type $message');
      break;
    case "INFO":
      logger.i('$type $message');
      break;
    case "ERROR":
      logger.e('$type $message');
      break;
  }
}

bool tokenExpired(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return true;

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final payloadMap = json.decode(utf8.decode(base64Url.decode(normalized)));

    if (payloadMap is! Map<String, dynamic>) return true;
    if (!payloadMap.containsKey('exp')) return true;

    final exp = payloadMap['exp'];
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return exp is int ? exp <= currentTimestamp : true;
  } catch (e) {
    print('tokenExpired error: $e');
    return true;
  }
}

String urlGenerator(String url) {
  return httpPrefix + url;
}

/// ################### Currency ################### ///
String formatPrice(int price) {
  return NumberFormat.currency(locale: 'ko_KR', symbol: '₩').format(price);
}

/// ################### Type Converter ################### ///
bool stringToBoolean(String ynString) {
  ynString = ynString.toUpperCase();
  if (ynString == 'Y') {
    return true;
  } else {
    return false;
  }
}

String booleanToString(bool ynBool) {
  if (ynBool == true) {
    return 'Y';
  } else {
    return 'N';
  }
}

import 'package:flutter/material.dart';
import 'package:packup/common/util.dart';

import 'package:packup/main.dart';

// 화이트 모드
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.brown,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blueAccent,
  ),
);

// 다크 모드
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[800],
      foregroundColor: Colors.white,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.grey,
  ),
);

// 초기 테마
Future<String> getDefaultTheme() async {
  String defaultTheme = await getSystemTheme();
  return defaultTheme;
}

// 테마 변경
switchThemeMode() {

  PackUp.themeNotifier.value = PackUp.themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

  saveSystemTheme(PackUp.themeNotifier.value.name);
}

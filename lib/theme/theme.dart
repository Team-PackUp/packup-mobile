import 'package:flutter/material.dart';
import 'package:packup/common/util.dart';
import 'package:packup/const/color.dart';

import 'package:packup/main.dart';

// 화이트 모드
ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: BACK_GROUND_COLOR_W,
  brightness: Brightness.light,
  primarySwatch: Colors.brown,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: TEXT_COLOR_W,
      foregroundColor: TEXT_COLOR_B,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: BACK_GROUND_COLOR_W,
    foregroundColor: TEXT_COLOR_B,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: TEXT_COLOR_B,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: BACK_GROUND_COLOR_W,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black45,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blueAccent,
  ),
);

// 다크 모드
ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: BACK_GROUND_COLOR_B,
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: TEXT_COLOR_B2,
      foregroundColor: TEXT_COLOR_W,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: BACK_GROUND_COLOR_B,
    foregroundColor: TEXT_COLOR_W,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: TEXT_COLOR_W,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: BACK_GROUND_COLOR_B,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white60,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
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

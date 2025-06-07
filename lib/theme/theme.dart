import 'package:flutter/material.dart';
import 'package:packup/common/util.dart';
import 'package:packup/const/color.dart';

import 'package:packup/main.dart';

// 화이트 모드
ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: BACK_GROUND_COLOR_W,
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: TEXT_COLOR_B),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey),
    filled: true,
    fillColor: LIGHT_GREY_COLOR,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.grey, width: 0.2),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.grey, width: 0.2),
    ),
    labelStyle: TextStyle(
      color: TEXT_COLOR_B,
    ),
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
    selectedItemColor: SELECTED,
    unselectedItemColor: LIGHT_MODE_UNSELECTED,
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
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: TEXT_COLOR_W),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey),
    filled: true,
    fillColor: DARK_GREY_COLOR,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.grey, width: 0.2),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.grey, width: 0.2),
    ),
    labelStyle: TextStyle(
      color: TEXT_COLOR_W,
    ),
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
    selectedItemColor: SELECTED,
    unselectedItemColor: DARK_MODE_UNSELECTED,
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

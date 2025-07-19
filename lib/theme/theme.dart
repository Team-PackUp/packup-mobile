import 'package:flutter/material.dart';
import 'package:packup/theme/shape/app_shapes.dart';
import 'package:packup/theme/sizes/app_sizes.dart';
import 'package:packup/theme/typographies/app_typographies.dart';

import 'package:packup/Common/util.dart';
import 'package:packup/main.dart';
import 'colors/app_colors.dart';

// ────────────────────────────────────────────────────────────────
// Theme Builder
// ────────────────────────────────────────────────────────────────
ThemeData buildTheme(AppColors colors) {
  return ThemeData(
    fontFamily: 'Aggro',
    useMaterial3: true,
    scaffoldBackgroundColor: colors.surface,

    textTheme: TextTheme(
      displayLarge: AppTypographies.get(size: AppFontSize.x4l, weight: AppFontWeight.bold, color: colors.onSurface),
      displayMedium: AppTypographies.get(size: AppFontSize.x3l, weight: AppFontWeight.bold, color: colors.onSurface),
      displaySmall: AppTypographies.get(size: AppFontSize.x2l, weight: AppFontWeight.semiBold, color: colors.onSurface),
      headlineLarge: AppTypographies.heading.copyWith(color: colors.onSurface),
      headlineMedium: AppTypographies.subheading.copyWith(color: colors.onSurface),
      bodyLarge: AppTypographies.body.copyWith(color: colors.onSurface),
      bodyMedium: AppTypographies.caption.copyWith(color: colors.onSurface),
      labelLarge: AppTypographies.get(size: AppFontSize.sm, weight: AppFontWeight.medium, color: colors.onSurface),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: AppShapes.elevationMd,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.fullRadius,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.gapMd,
          horizontal: AppSizes.gapLg,
        ),
        textStyle: AppTypographies.get(size: AppFontSize.base, weight: AppFontWeight.semiBold, color: colors.onPrimary),
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      centerTitle: true,
      elevation: AppShapes.elevationNone,
      titleTextStyle: AppTypographies.get(size: AppFontSize.lg, weight: AppFontWeight.semiBold, color: colors.onSurface),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.onSurface.withOpacity(0.6),
      selectedLabelStyle: AppTypographies.get(size: AppFontSize.sm, weight: AppFontWeight.semiBold, color: colors.primary),
      unselectedLabelStyle: AppTypographies.get(size: AppFontSize.sm, weight: AppFontWeight.normal, color: colors.onSurface.withOpacity(0.6)),
      type: BottomNavigationBarType.fixed,
      elevation: AppShapes.elevationMd,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.secondary,
      foregroundColor: colors.onSecondary,
      elevation: AppShapes.elevationSm,
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSizes.gapSm,
        horizontal: AppSizes.gapMd,
      ),
      border: OutlineInputBorder(
        borderRadius: AppShapes.mdRadius,
        borderSide: BorderSide(color: colors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppShapes.mdRadius,
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppShapes.mdRadius,
        borderSide: BorderSide(color: colors.primary, width: AppShapes.borderBase),
      ),
    ),

    cardTheme: CardTheme(
      elevation: AppShapes.elevationSm,
      shape: RoundedRectangleBorder(borderRadius: AppShapes.lgRadius),
      margin: const EdgeInsets.all(AppSizes.gapLg),
      color: colors.surface,
    ),

    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: AppShapes.xlRadius,
      ),
      backgroundColor: colors.surface,
      elevation: AppShapes.elevationMd,
      titleTextStyle: AppTypographies.get(size: AppFontSize.lg, weight: AppFontWeight.bold, color: colors.onSurface),
      contentTextStyle: AppTypographies.body.copyWith(color: colors.onSurface),
    ),
  );
}

// 초기 테마
Future<String> getDefaultTheme() async {
  String defaultTheme = await getSystemTheme();
  return defaultTheme;
}

// 테마 변경
switchThemeMode() {
  PackUp.themeNotifier.value =
  PackUp.themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  saveSystemTheme(PackUp.themeNotifier.value.name);
}
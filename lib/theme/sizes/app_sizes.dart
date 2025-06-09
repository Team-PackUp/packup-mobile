import 'package:flutter/material.dart';

/// 앱에서 사용하는 공통 크기 기준 정의 (Tailwind 기반)
abstract class AppSizes {
  // ───────────── Width & Height (Tailwind w-*, h-*) ─────────────
  static const double size0 = 0.0;
  static const double size1 = 4.0;
  static const double size2 = 8.0;
  static const double size3 = 12.0;
  static const double size4 = 16.0;
  static const double size5 = 20.0;
  static const double size6 = 24.0;
  static const double size8 = 32.0;
  static const double size10 = 40.0;
  static const double size12 = 48.0;
  static const double size16 = 64.0;
  static const double size20 = 80.0;
  static const double size24 = 96.0;
  static const double size32 = 128.0;
  static const double size40 = 160.0;
  static const double size48 = 192.0;
  static const double size56 = 224.0;
  static const double size64 = 256.0;

  // ───────────── Layout Sizes ─────────────
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double navbarHeight = 64.0;
  static const double bottomBarHeight = 72.0;
  static const double appBarHeight = 56.0;

  // ───────────── Icon Sizes ─────────────
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;

  // ───────────── Gap / Spacing (margin/padding between widgets) ─────────────
  static const double gapXs = 4.0;
  static const double gapSm = 8.0;
  static const double gapMd = 12.0;
  static const double gapLg = 16.0;
  static const double gapXl = 24.0;
  static const double gap2xl = 32.0;

  // ───────────── Text Field / Card Width ─────────────
  static const double formMinWidth = 280.0;
  static const double dialogMaxWidth = 560.0;
  static const double cardMaxWidth = 360.0;
  static const double fullWidth = double.infinity;
}

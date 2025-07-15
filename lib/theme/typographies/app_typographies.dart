import 'package:flutter/material.dart';

/// font-size
enum AppFontSize {
  xs(12),
  sm(14),
  base(16),
  lg(18),
  xl(20),
  x2l(24),
  x3l(30),
  x4l(36),
  x5l(48),
  x6l(60),
  x7l(72),
  x8l(96),
  x9l(128);

  final double size;
  const AppFontSize(this.size);
}

/// font-weight
enum AppFontWeight {
  thin(FontWeight.w100),
  extraLight(FontWeight.w200),
  light(FontWeight.w300),
  normal(FontWeight.w400),
  medium(FontWeight.w500),
  semiBold(FontWeight.w600),
  bold(FontWeight.w700),
  extraBold(FontWeight.w800),
  black(FontWeight.w900);

  final FontWeight weight;
  const AppFontWeight(this.weight);
}

/// 텍스트 스타일 정의
class AppTypographies {
  // ───────────── 기본 텍스트 색상 정의 ─────────────
  static const Color textBasePrimary = Color(0xFF242524);
  static const Color textBaseSecondary = Color(0xFF8C8D8B);
  static const Color textBaseTertiary = Color(0xFFA7A9A7);

  static const Color textPrimary = Color(0xFFE8618C);
  static const Color textSecondary = Color(0xFF636AE8);
  static const Color textTertiary = Color(0xFFFF382E);

  static const Color textError = Color(0xFFB3261E);
  static const Color textWarning = Color(0xFFFFB667);
  static const Color textSuccess = Color(0xFF7AF1A7);
  static const Color textInfo = Color(0xFF379AE6);

  static const Color textColorB = Colors.black87;
  static const Color textColorB2 = Colors.black54;
  static const Color textColorW = Colors.white70;
  static const Color textFiledFillColor = Color(0xFFD9D9D9);

  // ───────────── 기본 TextStyle 생성기 ─────────────
  static TextStyle get({
    AppFontSize size = AppFontSize.base,
    AppFontWeight weight = AppFontWeight.normal,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    return TextStyle(
      fontSize: size.size,
      fontWeight: weight.weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color ?? textBasePrimary,
    );
  }

  // ───────────── 대표 스타일 샘플 ─────────────
  static final TextStyle heading = get(
    size: AppFontSize.x2l,
    weight: AppFontWeight.bold,
  );

  static final TextStyle subheading = get(
    size: AppFontSize.lg,
    weight: AppFontWeight.medium,
    color: textBaseSecondary,
  );

  static final TextStyle body = get(
    size: AppFontSize.base,
    color: textBasePrimary,
  );

  static final TextStyle caption = get(
    size: AppFontSize.sm,
    weight: AppFontWeight.light,
    color: textBaseTertiary,
  );
}

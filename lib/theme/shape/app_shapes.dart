import 'package:flutter/material.dart';

/// 앱 전역에서 사용하는 radius, border, shadow, elevation 설정 통합
abstract class AppShapes {
  // ─────────────── Radius ───────────────
  static const double radiusNone = 0.0;
  static const double radiusSm = 2.0;
  static const double radiusBase = 4.0;
  static const double radiusMd = 6.0;
  static const double radiusLg = 8.0;
  static const double radiusXl = 12.0;
  static const double radius2xl = 16.0;
  static const double radius3xl = 24.0;
  static const double radiusFull = 999.0;

  static const BorderRadius noneRadius = BorderRadius.all(Radius.circular(radiusNone));
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius baseRadius = BorderRadius.all(Radius.circular(radiusBase));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius x2lRadius = BorderRadius.all(Radius.circular(radius2xl));
  static const BorderRadius x3lRadius = BorderRadius.all(Radius.circular(radius3xl));
  static const BorderRadius fullRadius = BorderRadius.all(Radius.circular(radiusFull));

  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) =>
      BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      );

  // ─────────────── Border Width ───────────────
  static const double borderThin = 1.0;
  static const double borderBase = 2.0;
  static const double borderThick = 4.0;

  // ─────────────── BoxShadow Presets ───────────────
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black38,
      blurRadius: 12,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> shadowNone = [];

  // ─────────────── Elevation ───────────────
  static const double elevationNone = 0.0;
  static const double elevationSm = 1.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
}

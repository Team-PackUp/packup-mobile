import 'package:flutter/material.dart';

class AppColors {
  final Brightness brightness; // 테마 밝기

  /* === JALIM ORIGINAL === */
  final Color lightGreyColor;
  final Color darkGreyColor;
  final Color primaryColor;
  final Color backGroundColorW;
  final Color backGrounColorB;

  /* === BASE COLOR === */
  final Color basePrimary;
  final Color baseSecondary;
  final Color baseTertiary;
  final Color onBase;

  /* === PRIMARY COLOR === */
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;

  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;

  /* === ERROR === */
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;

  /* === SUCCESS === */
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  /* === WARNING === */
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  /* === INFO === */
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  /* === BACKGROUND & SURFACE === */
  final Color surface;
  final Color onSurface;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;

  /* === OUTLINE === */
  final Color outline;
  final Color outlineVariant;

  /* === EFFECTS === */
  final Color shadow;
  final Color scrim;
  final Color surfaceTint;

  const AppColors({
    required this.brightness,

    // JALIM ORIGINAL
    required this.lightGreyColor,
    required this.darkGreyColor,
    required this.primaryColor,
    required this.backGroundColorW,
    required this.backGrounColorB,

    // Base
    required this.basePrimary,
    required this.baseSecondary,
    required this.baseTertiary,
    required this.onBase,

    // Primary
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,

    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,

    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,

    // Error
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,

    // Success
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,

    // Warning
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,

    // Info
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,

    // Surface
    required this.surface,
    required this.onSurface,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,

    // Outline
    required this.outline,
    required this.outlineVariant,

    // Effects
    required this.shadow,
    required this.scrim,
    required this.surfaceTint,
  });
}

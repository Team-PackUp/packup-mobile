import 'package:flutter/widgets.dart';

class SizeConfig {
  /// 디자인 기준
  static const double baseWidth = 360.0;
  static const double baseHeight = 690.0;

  /// 현재 화면 크기
  static Size sizeOf(BuildContext context) => MediaQuery.sizeOf(context);

  static double screenWidth(BuildContext context) => sizeOf(context).width;
  static double screenHeight(BuildContext context) => sizeOf(context).height;

  /// 가로/세로 스케일
  static double scaleX(BuildContext context) => screenWidth(context) / baseWidth;
  static double scaleY(BuildContext context) => screenHeight(context) / baseHeight;

  /// 균형 스케일(선택): 과도한 왜곡 방지용
  static double scaleBalanced(BuildContext context) =>
      (scaleX(context) + scaleY(context)) / 2;

  /// 디자인 px → 스케일 적용 (가로 기준)
  static double sX(BuildContext context, double designPx,
      {double? minScale, double? maxScale}) {
    var s = scaleX(context);
    if (minScale != null || maxScale != null) {
      s = s.clamp(minScale ?? s, maxScale ?? s);
    }
    return designPx * s;
  }

  /// 디자인 px → 스케일 적용 (세로 기준)
  static double sY(BuildContext context, double designPx,
      {double? minScale, double? maxScale}) {
    var s = scaleY(context);
    if (minScale != null || maxScale != null) {
      s = s.clamp(minScale ?? s, maxScale ?? s);
    }
    return designPx * s;
  }
}

/// context.sw, context.sh → 현재 기기 화면 크기 자체
/// context.sX(x), context.sY(y) → 디자인 기준 크기(x, y)를 현재 기기 비율에 맞춰 변환한 값
extension ContextSizeX on BuildContext {
  /// 현재 화면 크기/여백/텍스트 스케일
  Size get sz => MediaQuery.sizeOf(this);
  double get sw => sz.width;
  double get sh => sz.height;
  EdgeInsets get safe => MediaQuery.paddingOf(this);
  double get textScale => MediaQuery.textScaleFactorOf(this);

  /// 기준 스케일 (SizeConfig를 단일 소스로 사용)
  double get scaleX => sw / SizeConfig.baseWidth;
  double get scaleY => sh / SizeConfig.baseHeight;
  double get scaleBalanced => (scaleX + scaleY) / 2;

  /// 디자인 px → 스케일
  double sX(double designPx, {double? minScale, double? maxScale}) {
    var s = scaleX;
    if (minScale != null || maxScale != null) {
      s = s.clamp(minScale ?? s, maxScale ?? s);
    }
    return designPx * s;
  }

  double sY(double designPx, {double? minScale, double? maxScale}) {
    var s = scaleY;
    if (minScale != null || maxScale != null) {
      s = s.clamp(minScale ?? s, maxScale ?? s);
    }
    return designPx * s;
  }
}

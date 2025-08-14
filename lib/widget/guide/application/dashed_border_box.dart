import 'package:flutter/material.dart';

class DashedBorderBox extends StatelessWidget {
  const DashedBorderBox({
    super.key,
    required this.child,
    this.strokeWidth = 1.2,
    this.dashWidth = 6,
    this.dashGap = 4,
    this.radius = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 24),
    this.background = const Color(0xFFFAFAFA),
    this.borderColor = const Color(0xFFDFDFDF),
  });

  final Widget child;
  final double strokeWidth, dashWidth, dashGap, radius;
  final EdgeInsets padding;
  final Color background, borderColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashGap: dashGap,
        radius: radius,
        color: borderColor,
      ),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
    required this.radius,
    required this.color,
  });
  final double strokeWidth, dashWidth, dashGap, radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = color
          ..strokeWidth = strokeWidth;
    final path = Path()..addRRect(rrect);
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        final n = d + dashWidth;
        canvas.drawPath(m.extractPath(d, n.clamp(0, m.length)), paint);
        d = n + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter o) =>
      strokeWidth != o.strokeWidth ||
      dashWidth != o.dashWidth ||
      dashGap != o.dashGap ||
      radius != o.radius ||
      color != o.color;
}

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class SlideText extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const SlideText({
    super.key,
    required this.title,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    final textStyle = style ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        );

    return SizedBox(
      height: screenH * 0.03,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final span = TextSpan(text: title, style: textStyle);
          final tp = TextPainter(
            text: span,
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: double.infinity);

          final textWidth = tp.size.width;
          final maxWidth = constraints.maxWidth;

          if (textWidth > maxWidth) {
            return Marquee(
              text: title,
              style: textStyle,
              scrollAxis: Axis.horizontal,
              blankSpace: screenW * 0.05,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 0,
              accelerationDuration: const Duration(seconds: 1),
              decelerationDuration: const Duration(milliseconds: 500),
            );
          } else {
            return Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            );
          }
        },
      ),
    );
  }
}

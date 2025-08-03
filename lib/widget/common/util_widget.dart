import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomSnackBar {
  static void showError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  static void showResult(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

class CustomButton {
  static Widget textButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required String label,
    Color foregroundColor = Colors.white,
  }) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenW * 0.01),
      child: SizedBox(
        width: double.infinity,
        height: screenH * 0.05,
        child: TextButton(
          style: TextButton.styleFrom(
            elevation: 0,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: EdgeInsets.symmetric(vertical: screenH * 0.01),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenW * 0.02),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  static Widget textGestureDetector({
    required BuildContext context,
    required VoidCallback onTap,
    required String label,
    Color textColor = Colors.blue,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    EdgeInsetsGeometry? padding,
  }) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final effectivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: screenW * 0.01,
      vertical: screenH * 0.005,
    );

    return Padding(
      padding: effectivePadding,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }

  static Widget textIconButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    Color textColor = Colors.red,
    double iconSize = 20,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    EdgeInsetsGeometry? padding,
    MainAxisAlignment alignment = MainAxisAlignment.start,
  }) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: screenW * 0.05,
        );

    return Padding(
      padding: effectivePadding,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
        ),
        icon: Icon(icon, size: iconSize, color: textColor),
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

}



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
}

class ImageGallery {
  static Widget imageSlider({
    required BuildContext context,
    required List<String> images,
    required int activeIndex,
    required Function(int) onPageChanged,
  }) {
    final screenH = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        CarouselSlider(
          items: images.map((img) => Container(
            width: double.infinity,
            color: Colors.grey,
            child: Image.asset(
              img,
              fit: BoxFit.cover,
            ),
          ))
              .toList(),
          options: CarouselOptions(
            height: double.infinity,
            viewportFraction: 1.0,
            enableInfiniteScroll: true, // 무한 스크롤 여부
            onPageChanged: (index, reason) => onPageChanged(index),
          ),
        ),

        // 이미지 하단에 이미지 인덱스
        Container(
          margin: EdgeInsets.only(bottom: screenH * 0.01),
          alignment: Alignment.bottomCenter,
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: images.length,
            effect: JumpingDotEffect(
              dotHeight: screenH * 0.01,
              dotWidth: screenH * 0.01,
              activeDotColor: Colors.white,
              dotColor: Colors.white.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }
}


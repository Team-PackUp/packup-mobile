import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlider extends StatelessWidget {
  final CarouselSliderController controller;
  final List<String> images;
  final int activeIndex;
  final bool indicatorFlag;
  final Function(int) onPageChanged;
  final Function(String) onCLickImage;
  final Hero Function(dynamic context, dynamic imageUrl, dynamic index) imageBuilder;

  const ImageSlider({
    super.key,
    required this.controller,
    required this.images,
    required this.activeIndex,
    required this.onPageChanged,
    required this.onCLickImage,
    required this.imageBuilder,
    this.indicatorFlag = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    bool infiniteScrollFlag = images.length > 1;

    return Stack(
      children: [
        CarouselSlider(
          carouselController: controller,
          items: images.map((img) => GestureDetector(
            onTap: () => onCLickImage(img),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
                child: imageBuilder(context, img, images.indexOf(img)),
              ),
            ),
          )).toList(),
          options: CarouselOptions(
            initialPage: activeIndex,
            height: double.infinity,
            viewportFraction: 1.0,
            enableInfiniteScroll: infiniteScrollFlag,
            onPageChanged: (index, reason) => onPageChanged(index),
          ),
        ),

        // 이미지 밑에 하단에 인디케이터
        if(indicatorFlag)
          Container(
            margin: EdgeInsets.only(bottom: screenH * 0.05),
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
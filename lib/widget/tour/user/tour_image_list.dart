import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/common/image_viewer/image_slider.dart';
import '../../common/image_viewer/image_viewer.dart';

class TourImageList extends StatefulWidget {
  final List<String> toursImageUrl;

  const TourImageList({super.key, required this.toursImageUrl});


  @override
  _TourImageListState createState() => _TourImageListState();
}

class _TourImageListState extends State<TourImageList> {
  int activeIndex = 0;
  final CarouselSliderController carouselController = CarouselSliderController();


  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenH * 0.3,
      child: ImageSlider(
        controller: carouselController,
        images: widget.toursImageUrl,
        activeIndex: activeIndex,
        onPageChanged: (index) {
          setState(() {
            activeIndex = index;
          });
        },
          onCLickImage: (imageUrl) async {
            final index = widget.toursImageUrl.indexOf(imageUrl);

            final resultIndex = await Navigator.push<int>(
              context,
              PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.transparent,
                transitionDuration: const Duration(milliseconds: 300),
                reverseTransitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ImageViewer(
                    imageUrls: widget.toursImageUrl,
                    initialIndex: index,
                    onIndexChanged: (updatedIndex) {
                      setState(() {
                        activeIndex = updatedIndex;
                      });
                    },
                    transitionAnimation: animation,
                  );
                },
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );


            if (resultIndex != null) {
              Future.microtask(() {
                carouselController.jumpToPage(resultIndex);
              });
            }
          },

        // 이미지 자연스럽게
        imageBuilder: (context, imageUrl, index) {
          return Hero(
            tag: imageUrl,
            child: Image(
              image: _resolveImageProvider(imageUrl),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          );
      }

      ),
    );
  }
  ImageProvider _resolveImageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }
}

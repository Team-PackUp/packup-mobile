import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packup/widget/common/image_viewer/image_slider.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final ValueChanged<int>? onIndexChanged;
  final Animation<double>? transitionAnimation;

  const ImageViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
    this.onIndexChanged,
    this.transitionAnimation,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}


class _ImageViewerState extends State<ImageViewer> {
  late PageController _pageController;
  late int _currentIndex;
  late final CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _carouselController = CarouselSliderController();


    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;

    return AnimatedBuilder(
      animation: widget.transitionAnimation ?? kAlwaysCompleteAnimation,
      builder: (context, child) {
        final opacity = widget.transitionAnimation?.value ?? 1.0;

        return Scaffold(
          backgroundColor: Colors.black.withOpacity(opacity),
          body: Stack(
            children: [
              child!,
            ],
          ),
        );
      },
      child: Stack(
        children: [
          ImageSlider(
            controller: _carouselController,
            images: images,
            activeIndex: _currentIndex,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              widget.onIndexChanged?.call(index);
            },
            onCLickImage: (_) {},
            imageBuilder: (context, imageUrl, index) {
              final controller = PhotoViewController();

              return Hero(
                tag: imageUrl,
                child: PhotoViewGestureDetectorScope( // gesture 우선 처리 > 줌 상태에서 드래그할 때 다음 이미지 겹쳐지지 않게
                  axis: Axis.horizontal,
                  child: PhotoView(
                    controller: controller,
                    imageProvider: _resolveImageProvider(imageUrl),
                    backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 4,
                  ),
                ),
              );
            },

            indicatorFlag: true,
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context, _currentIndex),
            ),
          ),
        ],
      ),
    );
  }

}

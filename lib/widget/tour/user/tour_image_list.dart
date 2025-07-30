import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/widget/common/util_widget.dart';

class TourImageList extends StatefulWidget {
  final List<String> toursImageUrl;

  const TourImageList({super.key, required this.toursImageUrl});


  @override
  _TourImageListState createState() => _TourImageListState();
}

class _TourImageListState extends State<TourImageList> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 240,
      child: ImageGallery.imageSlider(
          context: context,
          images: widget.toursImageUrl,
          activeIndex: activeIndex,
          onPageChanged: (index) {
            setState(() {
              activeIndex = index;
            });
          },
      ),
    );
  }
}

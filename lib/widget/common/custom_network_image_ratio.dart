import 'package:flutter/material.dart';

class CustomNetworkImageRatio extends StatefulWidget {
  final String imageUrl;
  final double borderRadius;

  const CustomNetworkImageRatio({
    super.key,
    required this.imageUrl,
    this.borderRadius = 12.0,
  });

  @override
  State<CustomNetworkImageRatio> createState() => _CustomNetworkImageRatio();
}

class _CustomNetworkImageRatio extends State<CustomNetworkImageRatio> {
  double? _aspectRatio;

  @override
  void initState() {
    super.initState();

    final ImageStream stream = NetworkImage(widget.imageUrl).resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener((ImageInfo info, _) {
        final width = info.image.width.toDouble();
        final height = info.image.height.toDouble();
        if (mounted) {
          setState(() {
            _aspectRatio = width / height;
          });
        }
      }, onError: (error, _) {
        debugPrint("이미지 로드 실패: $error");
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_aspectRatio == null) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AspectRatio(
      aspectRatio: _aspectRatio!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Image.network(
          widget.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Text('이미지 로드 실패 >> ${widget.imageUrl}'),
        ),
      ),
    );
  }
}

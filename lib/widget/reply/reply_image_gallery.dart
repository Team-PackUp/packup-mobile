import 'package:flutter/material.dart';

import '../common/image_viewer/image_viewer.dart';

class ReplyImageGallery extends StatelessWidget {
  final List<String> urls;
  final DateTime createDate;

  const ReplyImageGallery({super.key, required this.urls, required this.createDate});

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(urls.length, (i) {
            final url = urls[i];
            final heroTag = url + createDate.toString();

            final isAsset = url.startsWith('assets/');

            return GestureDetector(
              onTap: () async {
                await Navigator.push<int>(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    barrierColor: Colors.black.withOpacity(0.85),
                    transitionDuration: const Duration(milliseconds: 250),
                    reverseTransitionDuration: const Duration(milliseconds: 250),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return ImageViewer(
                        imageUrls: urls,
                        initialIndex: i,
                        onIndexChanged: (_) {},
                        transitionAnimation: animation,
                      );
                    },
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: heroTag,
                  child: isAsset
                      ? Image.asset(
                    url,
                    width: 84,
                    height: 84,
                    fit: BoxFit.cover,
                  )
                      : Image.network(
                    url,
                    width: 84,
                    height: 84,
                    fit: BoxFit.cover,
                    loadingBuilder: (c, w, p) => const SizedBox(
                      width: 84,
                      height: 84,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorBuilder: (c, e, s) => const SizedBox(
                      width: 84,
                      height: 84,
                      child: Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

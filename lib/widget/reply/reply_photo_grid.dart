import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReplyPhotoGrid extends StatelessWidget {
  final List<XFile> photos;
  final int maxPhotos;
  final VoidCallback onAddPressed;
  final ValueChanged<int> onRemoveAt;

  const ReplyPhotoGrid({
    super.key,
    required this.photos,
    required this.maxPhotos,
    required this.onAddPressed,
    required this.onRemoveAt,
  });

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[];

    for (var i = 0; i < photos.length; i++) {
      tiles.add(Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(photos[i].path),
              fit: BoxFit.cover,
              width: 86,
              height: 86,
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () => onRemoveAt(i),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ));
    }

    if (photos.length < maxPhotos) {
      tiles.add(
        InkWell(
          onTap: onAddPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDFE3E8)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined, size: 28, color: Color(0xFF8E98A8)),
                SizedBox(height: 6),
                Text('사진 추가', style: TextStyle(fontSize: 12, color: Color(0xFF8E98A8))),
              ],
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: tiles,
    );
  }
}

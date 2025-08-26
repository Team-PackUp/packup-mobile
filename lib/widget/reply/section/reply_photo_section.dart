import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/widget/reply/reply_card.dart';
import 'package:packup/widget/reply/reply_photo_grid.dart';
import 'package:packup/widget/reply/reply_section_title.dart';

class ReplyPhotoSection extends StatelessWidget {
  final List<XFile> photos;
  final int maxPhotos;
  final VoidCallback onAddPressed;
  final void Function(int index) onRemoveAt;

  const ReplyPhotoSection({
    super.key,
    required this.photos,
    required this.maxPhotos,
    required this.onAddPressed,
    required this.onRemoveAt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ReplySectionTitle('사진 추가 (선택 사항 최대 5장)'),
        ReplyCard(
          child: ReplyPhotoGrid(
            photos: photos,
            maxPhotos: maxPhotos,
            onAddPressed: onAddPressed,
            onRemoveAt: onRemoveAt,
          ),
        ),
      ],
    );
  }
}

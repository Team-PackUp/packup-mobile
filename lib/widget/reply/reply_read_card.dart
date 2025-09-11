import 'package:flutter/material.dart';
import 'package:packup/widget/common/circle_profile_image.dart';
import 'package:packup/widget/reply/reply_image_gallery.dart';
import '../../Common/util.dart';
import '../common/image_viewer/image_viewer.dart';

class ReplyReadCard extends StatefulWidget {
  final String nickName;
  final String? avatarUrl;
  final String content;
  final int point;
  final DateTime? createdAt;
  final List<String>? imageUrls;

  const ReplyReadCard({
    super.key,
    required this.nickName,
    this.avatarUrl,
    required this.content,
    required this.point,
    this.createdAt,
    this.imageUrls,
  });

  @override
  State<ReplyReadCard> createState() => _ReplyReadCardState();
}

class _ReplyReadCardState extends State<ReplyReadCard> {
  @override
  Widget build(BuildContext context) {
    final urls = widget.imageUrls ?? const <String>[];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleProfileImage(
                    radius: 16,
                    imagePath: widget.avatarUrl,
                    profileAvatar: false,
                ),
                const SizedBox(width: 8),
                Text(widget.nickName, style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                  Text(
                    convertToYmd(widget.createdAt!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.content),
            ReplyImageGallery
              (urls: urls, createDate: widget.createdAt!,),
          ],
        ),
      ),
    );
  }
}

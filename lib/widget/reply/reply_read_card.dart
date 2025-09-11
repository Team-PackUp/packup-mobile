import 'package:flutter/material.dart';
import 'package:packup/widget/reply/reply_image_gallery.dart';
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
            // 간단한 헤더
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: widget.avatarUrl != null && widget.avatarUrl!.startsWith('http')
                      ? NetworkImage(widget.avatarUrl!)
                      : null,
                  child: (widget.avatarUrl == null || widget.avatarUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 18)
                      : null,
                ),
                const SizedBox(width: 8),
                Text(widget.nickName, style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                  Text(
                    _formatDate(widget.createdAt!),
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

  String _formatDate(DateTime dt) {
    return '${dt.year}-${_two(dt.month)}-${_two(dt.day)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}

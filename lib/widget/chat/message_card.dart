import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_network_image_ratio.dart';

import '../../common/util.dart';
import '../../const/color.dart';

class MessageCard extends StatelessWidget {
  final String message;
  final String createTime;
  final int sender;
  final int userSeq;
  final String fileFlag;
  final String? profileImagePath;

  const MessageCard({
    super.key,
    required this.message,
    required this.createTime,
    required this.sender,
    required this.userSeq,
    required this.fileFlag,
    this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = sender == userSeq;
    final imagePath = profileImagePath ?? 'assets/image/logo/logo.png';

    if (fileFlag == 'Y') {
      final imageWidget = SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: CustomNetworkImageRatio(
          imageUrl: fullFileUrl(message),
        ),
      );

      return Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMine
            ? [
          imageWidget,
          const SizedBox(width: 8),
          CircleAvatar(
            radius: MediaQuery.of(context).size.height * 0.03,
          ),
        ]
            : [
          CircleAvatar(
            radius: MediaQuery.of(context).size.height * 0.03,
          ),
          const SizedBox(width: 8),
          imageWidget,
        ],
      );
    }

    final bubble = IntrinsicWidth(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isMine ? MY_MESSAGE_BACKGROUND : YOUR_MESSAGE_BACKGROUND,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: isMine ? TEXT_COLOR_W : TEXT_COLOR_B,
                  fontSize: 15,
                  height: 1.5,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  createTime,
                  style: TextStyle(
                    color: isMine
                        ? TEXT_COLOR_W.withOpacity(0.7)
                        : TEXT_COLOR_B.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );




    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMine
            ? [
          bubble,
          const SizedBox(width: 6),
          CircleAvatar(
            radius: MediaQuery.of(context).size.height * 0.03,
            backgroundImage: profileImagePath != null
                ? NetworkImage(profileImagePath!)
                : AssetImage(imagePath) as ImageProvider,
          ),
        ]
            : [
          CircleAvatar(
            radius: MediaQuery.of(context).size.height * 0.03,
            backgroundImage: profileImagePath != null
                ? NetworkImage(profileImagePath!)
                : AssetImage(imagePath) as ImageProvider,
          ),
          const SizedBox(width: 6),
          bubble,
        ],
      ),
    );
  }
}

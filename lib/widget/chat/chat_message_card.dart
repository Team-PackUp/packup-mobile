import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_image_viewer.dart';
import 'package:packup/widget/common/custom_network_image_ratio.dart';

import '../../common/util.dart';
import '../../const/color.dart';

class ChatMessageCard extends StatelessWidget {
  final String message;
  final String createTime;
  final int sender;
  final int userSeq;
  final String fileFlag;
  final String? profileImagePath;

  const ChatMessageCard({
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
      final imageUrl = fullFileUrl(message);
      final String heroTag = createTime + message;   // 고유 태그

      final imageWidget = InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              transitionDuration: const Duration(milliseconds: 250),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (_, __, ___) =>
                  CustomImageViewer(imageUrl: imageUrl),
            ),
          );
        },
        child: Hero(
          tag: heroTag,                               // 동일 태그
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: CustomNetworkImageRatio(imageUrl: imageUrl),
          ),
        ),
      );


      final row = Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMine
            ? [
          imageWidget,
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          _avatar(context, imagePath),
        ]
            : [
          _avatar(context, imagePath),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          imageWidget,
        ],
      );
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: row,
      );
    }


    final bubble = IntrinsicWidth(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: MediaQuery.of(context).size.height * 0.01
          ),
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
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
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
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          _avatar(context, imagePath),
        ]
            : [
          _avatar(context, imagePath),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          bubble,
        ],
      ),
    );
  }

  Widget _avatar(
      BuildContext context,
      String? profileUrl,
      ) {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.height * 0.03,
      backgroundImage: profileUrl != null && profileUrl.isNotEmpty
          ? NetworkImage(profileUrl) : null,
    );
  }
}
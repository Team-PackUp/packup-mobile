import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:packup/widget/common/circle_profile_image.dart';
import 'package:packup/widget/common/custom_network_image_ratio.dart';
import 'package:path/path.dart';

import '../../common/util.dart';
import '../../const/color.dart';
import '../common/image_viewer/image_viewer.dart';

class ChatMessageCard extends StatelessWidget {
  final bool showProfile;
  final String message;
  final String createTime;
  final int sender;
  final int userSeq;
  final String fileFlag;
  final String? profileImagePath;

  const ChatMessageCard({
    super.key,
    required this.showProfile,
    required this.message,
    required this.createTime,
    required this.sender,
    required this.userSeq,
    required this.fileFlag,
    this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    final isMine = sender == userSeq;
    final imagePath = profileImagePath ?? 'assets/image/logo/logo.png';
    final avatarRadius = screenW * 0.08;

    final profileWidget = Visibility(
      visible: showProfile == true,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: CircleProfileImage(
        radius: avatarRadius,
        imagePath: imagePath,
      ),
    );

    if (fileFlag == 'Y') {
      final imageUrl = fullFileUrl(message);
      final String heroTag = createTime + message;   // 고유 태그

      final imageWidget = InkWell(
        onTap: () async {
          final resultIndex = await Navigator.push<int>(
            context,
            PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.transparent,
              transitionDuration: const Duration(milliseconds: 300),
              reverseTransitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) {
                return ImageViewer(
                  imageUrls: [imageUrl],
                  initialIndex: 0,
                  onIndexChanged: (updatedIndex) {
                    // setState(() {
                    //   activeIndex = updatedIndex;
                    // });
                  },
                  transitionAnimation: animation,
                );
              },
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        child: Hero(
          tag: heroTag,
          child: SizedBox(
            width: screenW * 0.4,
            child: CustomNetworkImageRatio(imageUrl: imageUrl),
          ),
        ),
      );


      final row = Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMine ? [
          imageWidget,
          SizedBox(width: screenW * 0.03),
          profileWidget,
        ] : [
          profileWidget,
          SizedBox(width: screenW * 0.03),
          imageWidget,
        ],
      );

      // 이거는 이미지
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenW * 0.03,
          vertical: screenH * 0.01,
        ),
        child: row,
      );
    }


    // 이거는 텍스트
    final bubble = IntrinsicWidth(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenW * 0.7,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenW * 0.03,
              vertical: screenH * 0.01
          ),
          decoration: BoxDecoration(
            color: isMine ? MY_MESSAGE_BACKGROUND : YOUR_MESSAGE_BACKGROUND,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.end,
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
              SizedBox(width: screenW * 0.03),
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
          horizontal: screenW * 0.03,
          vertical: screenH * 0.01,
      ),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMine
            ? [
          bubble,
          SizedBox(width: screenW * 0.03),
          profileWidget,
        ] : [
          profileWidget,
          SizedBox(width: screenW * 0.03),
          bubble,
        ],
      ),
    );
  }
}
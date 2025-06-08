import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:packup/widget/common/custom_network_image_ratio.dart';

import '../../common/util.dart';

class BubbleMessage extends StatelessWidget {
  final String message;
  final int sender;
  final int userSeq;
  final String fileFlag;
  final String? profileImagePath;

  const BubbleMessage({
    super.key,
    required this.message,
    required this.sender,
    required this.userSeq,
    required this.fileFlag,
    this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = sender == userSeq;
    final imagePath = profileImagePath ?? 'assets/icons/schedule/biceps_icon.png';

    // 파일 메시지
    if (fileFlag == 'Y') {
      final imageWidget = SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: CustomNetworkImageRatio(
          imageUrl: fullFileUrl(message),
        ),
      );

      return Row(
        mainAxisAlignment:
        isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
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




    // 텍스트 메시지
    return Row(
      mainAxisAlignment:
      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isMine
          ? [
        // 내 메시지
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          child: ChatBubble(
            clipper: ChatBubbleClipper4(type: BubbleType.sendBubble),
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.01,
            ),
            backGroundColor: Colors.grey[200]!,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        CircleAvatar(
          radius: MediaQuery.of(context).size.height * 0.03,
        ),
      ]
          : [
        // 상대 메시지
        CircleAvatar(
          radius: MediaQuery.of(context).size.height * 0.03,
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          child: ChatBubble(
            clipper: ChatBubbleClipper4(type: BubbleType.receiverBubble),
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.01,
            ),
            backGroundColor: Colors.blue[400]!,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


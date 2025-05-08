import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import '../../common/util.dart';

class BubbleMessage extends StatelessWidget {
  final String message;
  final int sender;
  final int userSeq;
  final bool fileFlag;
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

    return Row(
      mainAxisAlignment:
      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMine) ...[
          // CircleAvatar(
          //   backgroundImage: AssetImage(imagePath),
          //   radius: 25,
          // ),
          SizedBox(width: MediaQuery.of(context).size.height * 0.01),
        ],
        ChatBubble(
          clipper: ChatBubbleClipper4(
            type: isMine ? BubbleType.sendBubble : BubbleType.receiverBubble,
          ),
          alignment: isMine ? Alignment.topRight : Alignment.topLeft,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: fileFlag ?
            Image.network(
              fullFileUrl(message),
              errorBuilder: (context, error, stackTrace) => Text('이미지 로드 실패 >> ' + message),
            ) :
            Text(
              message,
              style: TextStyle(
                // color: isMine ? Colors.white : TEXT_COLOR_B,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

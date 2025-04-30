import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class BubbleMessage extends StatelessWidget {
  final String message;
  final int sender;
  final int userSeq;
  final String? profileImagePath;

  const BubbleMessage({
    super.key,
    required this.message,
    required this.sender,
    required this.userSeq,
    this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = sender == userSeq;
    final imagePath = profileImagePath ?? '';

    return Row(
      mainAxisAlignment:
      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMine) ...[
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 25,
          ),
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
            child: Text(
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

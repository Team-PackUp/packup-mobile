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

    // 파일 메시지
    if (fileFlag) {
      return Row(
        mainAxisAlignment:
        isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
              fullFileUrl(message),
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  Text('이미지 로드 실패 >> $message'),
            ),
          ),
        ],
      );
    }

    // 텍스트 메시지
    return Row(
      mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          child: ChatBubble(
            clipper: ChatBubbleClipper4(
              type: isMine ? BubbleType.sendBubble : BubbleType.receiverBubble,
            ),
            alignment: isMine ? Alignment.topRight : Alignment.topLeft,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.01,
            ),
            backGroundColor: isMine ? Colors.grey[200]! : Colors.blue[400]!,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isMine ? Colors.black : Colors.white,
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

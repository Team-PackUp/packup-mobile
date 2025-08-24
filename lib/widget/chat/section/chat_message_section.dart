import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/chat/chat_message_model.dart';
import '../../../provider/chat/chat_message_provider.dart';
import '../chat_message_list.dart';

class ChatMessageSection extends StatelessWidget {
  final ScrollController scrollController;
  final int userSeq;
  final int chatRoomSeq;

  final int lastReadSeq;

  final ValueChanged<int> onReadLastVisible;

  const ChatMessageSection({
    super.key,
    required this.scrollController,
    required this.userSeq,
    required this.chatRoomSeq,
    required this.lastReadSeq,
    required this.onReadLastVisible,
  });

  @override
  Widget build(BuildContext context) {
    final messages = context.select<ChatMessageProvider, List<ChatMessageModel>>(
          (p) => List<ChatMessageModel>.unmodifiable(p.chatMessage),
    );

    return ChatMessageList(
      messages: messages,
      scrollController: scrollController,
      userSeq: userSeq,
      chatRoomSeq: chatRoomSeq,
      lastReadSeq: lastReadSeq,
      onReadLastVisible: onReadLastVisible,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/chat/chat_message_provider.dart';
import '../../../provider/chat/chat_room_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/chat/chat_message_provider.dart';
import '../../../provider/chat/chat_room_provider.dart';
import '../chat_message_list.dart';

class ChatMessageSection extends StatefulWidget {
  final ScrollController scrollController;
  final int userSeq;
  final int chatRoomSeq;

  const ChatMessageSection({
    super.key,
    required this.scrollController,
    required this.userSeq,
    required this.chatRoomSeq,
  });

  @override
  State<ChatMessageSection> createState() => _ChatMessageSectionState();
}

class _ChatMessageSectionState extends State<ChatMessageSection> {
  late ChatMessageProvider _chatMessageProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _chatMessageProvider = context.read<ChatMessageProvider>();

      await _chatMessageProvider.getMessage(widget.chatRoomSeq);
      _chatMessageProvider.subscribeChatMessage(widget.chatRoomSeq);
    });
  }

  @override
  void dispose() {
    _chatMessageProvider.unSubscribeChatMessage(widget.chatRoomSeq);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<ChatMessageProvider>().chatMessage;

    return ChatMessageList(
      messages: messages,
      scrollController: widget.scrollController,
      userSeq: widget.userSeq,
      chatRoomSeq: widget.chatRoomSeq,
    );
  }
}

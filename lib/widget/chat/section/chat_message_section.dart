import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/chat/chat_message_model.dart';
import '../../../provider/chat/chat_message_provider.dart';
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
  ChatMessageProvider? _chatMessageProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final p = context.read<ChatMessageProvider>();
      _chatMessageProvider = p;

      await p.getMessage(widget.chatRoomSeq);
      p.subscribeChatMessage(widget.chatRoomSeq);
    });
  }

  @override
  void dispose() {
    _chatMessageProvider?.unSubscribeChatMessage(widget.chatRoomSeq);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final messages = context.select<ChatMessageProvider, List<ChatMessageModel>>(
          (p) => List<ChatMessageModel>.unmodifiable(p.chatMessage),
    );

    return ChatMessageList(
      messages: messages,
      scrollController: widget.scrollController,
      userSeq: widget.userSeq,
      chatRoomSeq: widget.chatRoomSeq,
    );
  }
}

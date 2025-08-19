// chat_message_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';

import '../../../model/chat/chat_message_model.dart';
import '../../../model/chat/chat_read_model.dart';
import '../../../provider/chat/chat_message_provider.dart';
import '../../../provider/chat/chat_room_provider.dart';
import '../../../common/util.dart';
import 'chat_message_card.dart';
import 'chat_message_separator.dart';

class ChatMessageList extends StatefulWidget {
  final List<ChatMessageModel> messages;
  final int userSeq;
  final int chatRoomSeq;
  final ScrollController scrollController;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.userSeq,
    required this.chatRoomSeq,
    required this.scrollController,
  });

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  List<dynamic> _groupedCache = const [];
  int _sigLen = 0;
  int? _sigLastSeq;

  @override
  void didUpdateWidget(covariant ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final len = widget.messages.length;
    final lastSeq = len > 0 ? widget.messages.last.seq : null;
    if (len != _sigLen || lastSeq != _sigLastSeq) {
      _groupedCache = _buildGroupedMessagesWithDateSeparators(widget.messages);
      _sigLen = len;
      _sigLastSeq = lastSeq;
    }
  }

  @override
  void initState() {
    super.initState();
    final len = widget.messages.length;
    _groupedCache = _buildGroupedMessagesWithDateSeparators(widget.messages);
    _sigLen = len;
    _sigLastSeq = len > 0 ? widget.messages.last.seq : null;
  }

  @override
  Widget build(BuildContext context) {

    final lastReadSeq = context.select<ChatMessageProvider, int>(
          (p) => p.lastReadMessageSeq ?? 0,
    );
    final chatRoomProvider = context.read<ChatRoomProvider>();

    return ListView.builder(
      controller: widget.scrollController,
      reverse: true,
      padding: EdgeInsets.zero,
      itemCount: _groupedCache.length,
      itemBuilder: (context, index) {
        final item = _groupedCache[index];

        if (item is DateTime) {
          return DateSeparator(dateText: DateFormat('yyyy-MM-dd').format(item));
        }

        if (item is List<ChatMessageModel>) {
          return Column(
            key: ValueKey('group-$index-${item.first.seq}-${item.length}'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(item.length, (i) {
              final message = item[i];
              final isFirstInGroup = i == 0;
              final isLatestMessage = index == 0 && isFirstInGroup;

              Widget messageWidget = ChatMessageCard(
                key: ValueKey('msg-${message.seq}'),
                showProfile: isFirstInGroup,
                message: message.message ?? '',
                createTime: convertToHm(message.createdAt!),
                userSeq: widget.userSeq,
                sender: message.userSeq!,
                profileImagePath: message.profileImagePath,
                fileFlag: message.fileFlag ?? 'N',
              );

              if (isLatestMessage) {
                messageWidget = VisibilityDetector(
                  key: Key('last-message-${message.seq}'),
                  onVisibilityChanged: (info) {
                    final isUnread = lastReadSeq < (message.seq ?? 0);
                    if (info.visibleFraction > 0.8 && isUnread) {
                      context.read<ChatMessageProvider>().readChatMessage(
                        ChatReadModel(
                          chatRoomSeq: widget.chatRoomSeq,
                          lastReadMessageSeq: message.seq!,
                        ),
                      );
                      chatRoomProvider.readMessageThisRoom(widget.chatRoomSeq);
                    }
                  },
                  child: messageWidget,
                );
              }

              return messageWidget;
            }),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ───── helper ─────

  List<dynamic> _buildGroupedMessagesWithDateSeparators(List<ChatMessageModel> messages) {
    final List<dynamic> result = [];
    if (messages.isEmpty) return result;

    DateTime? currentGroupDate;
    int? lastSender;
    List<ChatMessageModel> currentGroup = [];

    for (int i = messages.length - 1; i >= 0; i--) {
      final message = messages[i];
      final messageDate = message.createdAt!;
      final isNewDate = currentGroupDate == null || !isSameDate(currentGroupDate, messageDate);
      final isNewSender = lastSender == null || lastSender != message.userSeq;

      if (isNewDate) {
        if (currentGroup.isNotEmpty) {
          result.insert(0, currentGroup);
          currentGroup = [];
        }
        result.insert(0, messageDate);
        currentGroupDate = messageDate;
        lastSender = message.userSeq;
      } else if (isNewSender) {
        if (currentGroup.isNotEmpty) {
          result.insert(0, currentGroup);
          currentGroup = [];
        }
        lastSender = message.userSeq;
      }
      currentGroup.add(message);
    }
    if (currentGroup.isNotEmpty) {
      result.insert(0, currentGroup);
    }
    return result;
  }

  bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

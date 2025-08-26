// chat_message_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../model/chat/chat_message_model.dart';
import '../../../common/util.dart';
import 'chat_message_card.dart';
import 'chat_message_separator.dart';

class ChatMessageList extends StatefulWidget {
  final List<ChatMessageModel> messages;
  final int userSeq;
  final int chatRoomSeq;
  final ScrollController scrollController;

  final int lastReadSeq;

  final ValueChanged<int> onReadLastVisible;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.userSeq,
    required this.chatRoomSeq,
    required this.scrollController,
    required this.lastReadSeq,
    required this.onReadLastVisible,
  });

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  List<dynamic> _groupedCache = const [];
  int _sigLen = 0;
  int? _sigLastSeq;

  @override
  void initState() {
    super.initState();
    _rebuildCache();
  }

  @override
  void didUpdateWidget(covariant ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final len = widget.messages.length;
    final lastSeq = len > 0 ? widget.messages.last.seq : null;
    if (len != _sigLen || lastSeq != _sigLastSeq) {
      _rebuildCache();
    }
  }

  void _rebuildCache() {
    final len = widget.messages.length;
    _groupedCache = _buildGroupedMessagesWithDateSeparators(widget.messages);
    _sigLen = len;
    _sigLastSeq = len > 0 ? widget.messages.last.seq : null;
  }

  @override
  Widget build(BuildContext context) {
    final lastReadSeq = widget.lastReadSeq;

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
                final isNewestGroup = index == 0;
                final isNewestInGroup = i == item.length - 1;
                final isLatestMessage = isNewestGroup && isNewestInGroup;

                Widget messageWidget = ChatMessageCard(
                  key: ValueKey('msg-${message.seq ?? message.createdAt?.microsecondsSinceEpoch}'),
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
                    key: Key('last-message-${message.seq ?? message.createdAt?.microsecondsSinceEpoch}'),
                    onVisibilityChanged: (info) {
                      final seq = message.seq ?? 0;
                      if (seq == 0) return;
                      final isUnread = lastReadSeq < seq;
                      if (info.visibleFraction > 0.6 && isUnread) {
                        widget.onReadLastVisible(seq);
                      }
                    },
                    child: messageWidget,
                  );
                }

                return messageWidget;
              })

          );
        }

        return const SizedBox.shrink();
      },
    );
  }

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

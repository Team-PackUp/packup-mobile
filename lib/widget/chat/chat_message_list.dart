import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../common/util.dart';
import '../../../model/chat/chat_message_model.dart';
import '../../../model/chat/chat_read_model.dart';
import '../../../provider/chat/chat_message_provider.dart';
import '../../../provider/chat/chat_room_provider.dart';
import 'package:provider/provider.dart';

import 'chat_message_card.dart';
import 'chat_message_separator.dart';

class ChatMessageList extends StatelessWidget {
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
  Widget build(BuildContext context) {

    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    final groupedList = _buildGroupedMessagesWithDateSeparators(messages);
    final chatMessageProvider = context.watch<ChatMessageProvider>();
    final chatRoomProvider = context.read<ChatRoomProvider>();

    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: EdgeInsets.only(
        left: screenW * 0.02,
        right: screenW * 0.02,
        bottom: screenH * 0.02,
      ),
      itemCount: groupedList.length,
      itemBuilder: (context, index) {
        final item = groupedList[index];

        if (item is DateTime) {
          return DateSeparator(
            dateText: DateFormat('yyyy-MM-dd').format(item),
          );
        }

        if (item is List<ChatMessageModel>) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: item.asMap().entries.map((entry) {
              final i = entry.key;
              final message = entry.value;

              final isLatestMessage = index == 0 && i == 0;

              Widget messageWidget = ChatMessageCard(
                message: message.message ?? '',
                createTime: convertToHm(message.createdAt!),
                userSeq: userSeq,
                sender: message.userSeq!,
                profileImagePath: message.profileImagePath,
                fileFlag: message.fileFlag ?? 'N',
              );

              if (isLatestMessage) {
                messageWidget = VisibilityDetector(
                  key: Key('last-message-${message.seq}'),
                  onVisibilityChanged: (info) {
                    final isUnread = chatMessageProvider.lastReadMessageSeq! < message.seq!;
                    if (info.visibleFraction > 0.8 && isUnread) {
                      chatMessageProvider.readChatMessage(ChatReadModel(
                        chatRoomSeq: chatRoomSeq,
                        lastReadMessageSeq: message.seq!,
                      ));
                      chatRoomProvider.readMessageThisRoom(chatRoomSeq);
                    }
                  },
                  child: messageWidget,
                );
              }

              return messageWidget;
            }).toList(),
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


  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

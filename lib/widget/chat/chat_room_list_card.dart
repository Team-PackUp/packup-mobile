import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/chat/chat_room_divider.dart';
import 'package:packup/model/chat/chat_room_model.dart';

class ChatRoomListCard extends StatelessWidget {
  final int userSeq;
  final ChatRoomModel room;
  final Function(int) onTapRead;

  const ChatRoomListCard({
    super.key,
    required this.userSeq,
    required this.room,
    required this.onTapRead,
  });

  @override
  Widget build(BuildContext context) {
    String unReadCount = room.unReadCount! > 9 ? "9+" : room.unReadCount.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          onTapRead(room.seq!);

          final encodedTitle = Uri.encodeComponent(room.title ?? '');
          context.push('/chat_message/${room.seq}/$encodedTitle/$userSeq');
        },
        child: ChatRoomDivider(
          title: room.title ?? '',
          unReadCount: unReadCount,
          lastMessage: room.lastMessage,
          lastMessageDate: room.lastMessageDate,
          fileFlag: room.fileFlag ?? 'N',
        ),
      ),
    );
  }
}

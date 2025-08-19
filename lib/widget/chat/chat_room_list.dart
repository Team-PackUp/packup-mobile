import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/chat/chat_room_card.dart';
import 'package:packup/model/chat/chat_room_model.dart';

class ChatRoomList extends StatelessWidget {
  final List<ChatRoomModel> rooms;
  final ScrollController? scrollController;
  final int userSeq;
  final Function(int) onTapRead;

  const ChatRoomList({
    super.key,
    required this.rooms,
    required this.userSeq,
    this.scrollController,
    required this.onTapRead,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        final unReadCount = room.unReadCount! > 9 ? "9+" : room.unReadCount.toString();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: InkWell(
            onTap: () {
              onTapRead(room.seq!);

              final encodedTitle = Uri.encodeComponent(room.title ?? '');
              context.push('/chat_message/${room.seq}/$encodedTitle/$userSeq');
            },
            child: ChatRoomCard(
              key: ValueKey(room.seq),
              title: room.title ?? '',
              unReadCount: unReadCount,
              profileImagePath: room.user?.profileImagePath,
              lastMessage: room.lastMessage,
              lastMessageDate: room.lastMessageDate,
              fileFlag: room.fileFlag ?? 'N',
              // freezeProfileImage: true, // 기본값
            ),
          ),
        );
      },
    );
  }
}

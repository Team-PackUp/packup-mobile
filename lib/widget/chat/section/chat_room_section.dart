import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/chat/chat_room_provider.dart';
import '../../common/custom_empty_list.dart';
import '../chat_room_list_card.dart';

class ChatRoomSection extends StatelessWidget {
  final ScrollController scrollController;
  final int userSeq;

  const ChatRoomSection({
    super.key,
    required this.scrollController,
    required this.userSeq,
  });

  @override
  Widget build(BuildContext context) {
    final chatRoomProvider = context.watch<ChatRoomProvider>();
    final chatRooms = chatRoomProvider.chatRoom;

    if (chatRooms.isEmpty && !chatRoomProvider.isLoading) {
      return const CustomEmptyList(
        message: '참여 중인 채팅방이 없습니다.',
        icon: Icons.chat_bubble_outline,
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: chatRooms.length,
      itemBuilder: (context, index) {
        final room = chatRooms[index];
        return ChatRoomListCard(
          room: room,
          userSeq: userSeq,
          onTapRead: (int seq) {
            context.read<ChatRoomProvider>().readMessageThisRoom(seq);
          },
        );
      },
    );
  }
}

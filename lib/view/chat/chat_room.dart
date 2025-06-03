import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/chat/chat_room_provider.dart';
import 'package:packup/common/util.dart';
import 'package:provider/provider.dart';

import '../../widget/common/custom_appbar.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatRoomContent();
  }
}

class ChatRoomContent extends StatefulWidget {
  const ChatRoomContent({super.key});

  @override
  State<ChatRoomContent> createState() => _ChatRoomContentState();
}

class _ChatRoomContentState extends State<ChatRoomContent> {
  final ScrollController _scrollController = ScrollController();
  late ChatRoomProvider _chatRoomProvider;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _chatRoomProvider = context.read<ChatRoomProvider>();
      await _chatRoomProvider.getRoom();

      _chatRoomProvider.subscribeChatRoom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _chatRoomProvider.unSubscribeChatRoom();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<ChatRoomProvider>().getRoom();
    }
  }

  @override
  Widget build(BuildContext context) {
    _chatRoomProvider = context.watch<ChatRoomProvider>();

    final chatRooms = _chatRoomProvider.chatRoom.toList();

    return Scaffold(
      appBar: CustomAppbar(title: "채팅 목록",),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final room = chatRooms[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: InkWell(
                    onTap: () async {
                      final userSeq = await decodeTokenInfo();
                      context.push('/chat_message/${room.seq}/$userSeq');
                      _chatRoomProvider.readMessageThisRoom(room.seq!);
                    },
                    child: ChatRoomCard(
                        title: room.seq.toString(),
                      unReadCount: room.unReadCount.toString(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatRoomCard extends StatelessWidget {
  final String title;
  final String unReadCount;

  const ChatRoomCard({
    super.key,
    required this.title,
    required this.unReadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),

          // 뱃지 추가
          if (unReadCount != "0")
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unReadCount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


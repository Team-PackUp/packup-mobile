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
      body: RefreshIndicator(
        onRefresh: () async {
          await _chatRoomProvider.getRoom();
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),// 데이터 별로 없을때 테스트할 때 추가
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  final room = chatRooms[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: InkWell(
                      onTap: () async {
                        _chatRoomProvider.readMessageThisRoom(room.seq!);

                        final userSeq = await decodeTokenInfo();
                        context.push('/chat_message/${room.seq}/$userSeq');
                      },
                      child: ChatRoomCard(
                          title: room.seq.toString(),
                    unReadCount: room.unReadCount.toString(),
                    lastMessage: room.lastMessage,
                    lastMessageDate: room.lastMessageDate,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatRoomCard extends StatelessWidget {
  final String title;
  final String unReadCount;
  final String? lastMessage;
  final DateTime? lastMessageDate;

  const ChatRoomCard({
    super.key,
    required this.title,
    required this.unReadCount,
    this.lastMessage,
    this.lastMessageDate
  });

  @override
  Widget build(BuildContext context) {
    print(lastMessage);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),

                // 마지막 메시지
                if (lastMessage != null && lastMessage!.trim().isNotEmpty)
                  Text(
                    lastMessage!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
              ],
            ),
          ),

          // 날짜 조건에 따라 포맷 변경 필요
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (lastMessageDate != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      convertToHm(lastMessageDate!),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (unReadCount != "0")
                  Container(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}


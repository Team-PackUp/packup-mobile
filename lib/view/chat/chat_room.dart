import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/chat/chat_room_provider.dart';
import 'package:packup/common/util.dart';
import 'package:packup/widget/chat/chat_room_divider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widget/common/custom_appbar.dart';

class ChatRoom extends StatelessWidget {

  final bool deepLinkFlag;

  const ChatRoom({
    super.key,
    required this.deepLinkFlag,
  });

  @override
  Widget build(BuildContext context) {
    return ChatRoomContent(deepLinkFlag: deepLinkFlag,);
  }
}

class ChatRoomContent extends StatefulWidget {
  final bool deepLinkFlag;

  const ChatRoomContent({super.key, required this.deepLinkFlag});

  @override
  State<ChatRoomContent> createState() => _ChatRoomContentState();
}

class _ChatRoomContentState extends State<ChatRoomContent> {
  final ScrollController _scrollController = ScrollController();
  late ChatRoomProvider _chatRoomProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _chatRoomProvider = context.read<ChatRoomProvider>();
      await _chatRoomProvider.getRoom();
      await _chatRoomProvider.subscribeChatRoom();

      if (!mounted) return;

      if (widget.deepLinkFlag) {
        final userSeq = await decodeTokenInfo();
        final room = _chatRoomProvider.chatRoom.firstOrNull;

        if (room != null) {
          Future.microtask(() {
            if (mounted) {
              context.push('/chat_message/${room.seq}/${room.title}/$userSeq');
            }
          });
        }
      }
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _chatRoomProvider.unSubscribeChatRoom();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ChatRoomProvider>().getRoom();
    }
  }

  @override
  Widget build(BuildContext context) {
    _chatRoomProvider = context.watch<ChatRoomProvider>();

    final chatRooms = _chatRoomProvider.chatRoom.toList();

    return Scaffold(
      appBar: CustomAppbar(
        arrowFlag: false,
        title: AppLocalizations.of(context)!.chat,
      ),
      body: Column(
        children: [
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              // physics: const AlwaysScrollableScrollPhysics(),// 데이터 별로 없을때 테스트할 때 추가
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final room = chatRooms[index];

                String unReadCount;
                if (room.unReadCount! > 9) {
                  unReadCount = "9+";
                } else {
                  unReadCount = room.unReadCount.toString();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: InkWell(
                    onTap: () async {
                      _chatRoomProvider.readMessageThisRoom(room.seq!);

                      final userSeq = await decodeTokenInfo();
                      context.push(
                        '/chat_message/${room.seq}/${room.title}/$userSeq',
                      );
                    },
                    child: ChatRoomDivider(
                      title: room.title.toString(),
                      unReadCount: unReadCount,
                      lastMessage: room.lastMessage,
                      lastMessageDate: room.lastMessageDate,
                      fileFlag: room.fileFlag!,
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

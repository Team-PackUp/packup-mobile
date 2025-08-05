import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/chat/chat_room_provider.dart';
import 'package:packup/common/util.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../common/deep_link/handle_router.dart';
import '../../widget/chat/section/chat_room_section.dart';
import '../../widget/common/custom_appbar.dart';

class ChatRoom extends StatelessWidget {

  final int? chatRoomId;

  const ChatRoom({
    super.key,
    this.chatRoomId,
  });

  @override
  Widget build(BuildContext context) {
    return ChatRoomContent(
      chatRoomId: chatRoomId,
    );
  }
}

class ChatRoomContent extends StatefulWidget {
  final int? chatRoomId;

  const ChatRoomContent({
    super.key,
    this.chatRoomId,
  });

  @override
  State<ChatRoomContent> createState() => _ChatRoomContentState();
}

class _ChatRoomContentState extends State<ChatRoomContent> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  late ChatRoomProvider _chatRoomProvider;
  int userSeq = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final seq = await decodeTokenInfo();
      _chatRoomProvider = context.read<ChatRoomProvider>();
      await _chatRoomProvider.getRoom();
      await _chatRoomProvider.subscribeChatRoom();
      if (!mounted) return;
      setState(() => userSeq = seq);
      _maybeNavigateToChatDetail();
    });
  }

  void _maybeNavigateToChatDetail() async {
    if (!mounted || widget.chatRoomId == null) return;

    logger("채팅내역으로 바로 이동합니다.", 'INFO');

    final room = _chatRoomProvider.chatRoom.firstWhere(
          (e) => e.seq == widget.chatRoomId,
    );

    final encodedTitle = Uri.encodeComponent(room.title ?? '');
    DeepLinkRouter.clearPayload(3);
    context.push('/chat_message/${room.seq}/$encodedTitle/$userSeq');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _chatRoomProvider.unSubscribeChatRoom();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeNavigateToChatDetail();
    }
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      if (!_chatRoomProvider.isLoading) {
        _chatRoomProvider.getRoom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        arrowFlag: false,
        title: AppLocalizations.of(context)!.chat,
      ),
      body: Column(
        children: [
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: ChatRoomSection(
              scrollController: _scrollController,
              userSeq: userSeq,
            ),
          ),
        ],
      ),
    );
  }
}

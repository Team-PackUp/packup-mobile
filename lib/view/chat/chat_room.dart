import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/common/util.dart';
import 'package:packup/provider/chat/chat_room_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/deep_link/handle_router.dart';
import '../../widget/chat/section/chat_room_section.dart';
import '../../widget/common/category_filter.dart';
import '../../widget/common/custom_appbar.dart';

class ChatRoom extends StatelessWidget {
  final int? chatRoomId;

  const ChatRoom({super.key, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return ChatRoomContent(chatRoomId: chatRoomId);
  }
}

class ChatRoomContent extends StatefulWidget {
  final int? chatRoomId;
  const ChatRoomContent({super.key, this.chatRoomId});

  @override
  State<ChatRoomContent> createState() => _ChatRoomContentState();
}

class _ChatRoomContentState extends State<ChatRoomContent>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  ChatRoomProvider? _chatRoomProvider;
  int userSeq = 0;

  static const Map<int, String> _filterMap = {
    0: '전체',
    1: '안읽은 채팅',
    2: '내가 가이드',
  };
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final seq = await decodeTokenInfo();
      final provider = context.read<ChatRoomProvider>();
      _chatRoomProvider = provider;

      await provider.getRoom();
      await provider.subscribeChatRoom();

      if (!mounted) return;
      setState(() => userSeq = seq);
      _maybeNavigateToChatDetail();
    });
  }

  void _maybeNavigateToChatDetail() {
    if (!mounted || widget.chatRoomId == null || _chatRoomProvider == null) return;
    try {
      final room = _chatRoomProvider!.chatRoom.firstWhere(
            (e) => e.seq == widget.chatRoomId,
      );
      final encodedTitle = Uri.encodeComponent(room.title ?? '');
      DeepLinkRouter.clearPayload(3);
      context.push('/chat_message/${room.seq}/$encodedTitle/$userSeq');
    } catch (_) {

    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _chatRoomProvider?.unSubscribeChatRoom();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeNavigateToChatDetail();
    }
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    final atEnd = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 40;
    if (atEnd) {
      final p = _chatRoomProvider;
      if (p != null && !p.isLoading) {
        p.getRoom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final activeIdx = context.select<ChatRoomProvider, int>(
          (p) => p.activeFilterIdx,
    );

    return Scaffold(
      appBar: CustomAppbar(
        arrowFlag: false,
        title: AppLocalizations.of(context)!.chat,
      ),
      body: Column(
        children: [
          const Divider(height: 1, thickness: 1),

          CategoryFilter<int>(
            items: _filterMap.keys.toList(growable: true),
            labelBuilder: (i) => _filterMap[i] ?? '$i',
            mode: SelectionMode.single,
            initialSelectedItems: [activeIdx],
            allowDeselectInSingle: false,
            onSelectionChanged: (selected) {
              final idx = selected.isNotEmpty ? selected.first : 0;
              context.read<ChatRoomProvider>().filterChatRoom(idx);
            },
          ),

          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 8),

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

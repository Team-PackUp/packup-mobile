import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/provider/chat/chat_message_provider.dart';
import 'package:packup/model/chat/chat_message_model.dart';
import 'package:packup/widget/chat/chat_message_input.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import '../../model/chat/chat_read_model.dart';
import '../../provider/chat/chat_room_provider.dart';
import '../../widget/chat/section/chat_message_section.dart';
import '../../widget/common/circle_profile_image.dart';

class ChatMessage extends StatelessWidget {
  final int chatRoomSeq;
  final String title;
  final int userSeq;

  const ChatMessage({
    super.key,
    required this.chatRoomSeq,
    required this.title,
    required this.userSeq,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatMessageProvider(),
      child: ChatMessageContent(
        chatRoomSeq: chatRoomSeq,
        title: title,
        userSeq: userSeq,
      ),
    );
  }
}

class ChatMessageContent extends StatefulWidget {
  final int chatRoomSeq;
  final String title;
  final int userSeq;

  const ChatMessageContent({
    super.key,
    required this.chatRoomSeq,
    required this.title,
    required this.userSeq,
  });

  @override
  _ChatMessageContentState createState() => _ChatMessageContentState();
}

class _ChatMessageContentState extends State<ChatMessageContent>
    with WidgetsBindingObserver {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  ChatMessageProvider? _chatMessageProvider;

  final ImagePicker _picker = ImagePicker();

  static const double _threshold = 200.0;
  bool _isPaginating = false;
  bool _resumedSyncing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scrollController = ScrollController()..addListener(_scrollListener);
    _controller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final p = context.read<ChatMessageProvider>();
      _chatMessageProvider = p;

      // 최초 진입: 재구독(idempotent) + 1페이지 리프레시(누락분 보정)
      await p.subscribeChatMessage(widget.chatRoomSeq);
      await p.refreshFirstMessage(chatRoomSeq: widget.chatRoomSeq);

      // 필요 시 아래에서 스크롤을 최신으로 이동
      _scrollBottom();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!mounted) return;
    if (state == AppLifecycleState.resumed) {
      if (_resumedSyncing) return;
      _resumedSyncing = true;
      try {
        final p = context.read<ChatMessageProvider>();

        await p.subscribeChatMessage(widget.chatRoomSeq);
        await p.refreshFirstMessage(chatRoomSeq: widget.chatRoomSeq);

        _scrollBottom();
      } finally {
        _resumedSyncing = false;
      }
    }
  }

  void _scrollListener() async {
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position;
    final bool nearBottom = pos.pixels >= (pos.maxScrollExtent - _threshold);

    if (!nearBottom || _isPaginating || (_chatMessageProvider?.isLoading ?? true)) {
      return;
    }

    _isPaginating = true;
    try {
      await _chatMessageProvider?.getMessage(widget.chatRoomSeq);
    } finally {
      _isPaginating = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scrollController.dispose();
    _chatMessageProvider?.unSubscribeChatMessage(widget.chatRoomSeq);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const appBarProfile = CircleProfileImage(radius: 18);
    final lastReadSeq = context.select<ChatMessageProvider, int>(
          (p) => p.lastReadMessageSeq,
    );

    return Scaffold(
      appBar: CustomAppbar(
        title: widget.title,
        profile: appBarProfile,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Align(
                alignment: Alignment.topCenter,
                child: ChatMessageSection(
                  scrollController: _scrollController,
                  userSeq: widget.userSeq,
                  chatRoomSeq: widget.chatRoomSeq,
                  lastReadSeq: lastReadSeq,
                  onReadLastVisible: (int seq) {
                    final msgProvider = context.read<ChatMessageProvider>();

                    if (seq <= msgProvider.lastReadMessageSeq) return;

                    msgProvider.readChatMessage(ChatReadModel(
                      chatRoomSeq: widget.chatRoomSeq,
                      lastReadMessageSeq: seq,
                    ));

                    context.read<ChatRoomProvider>().readMessageThisRoom(widget.chatRoomSeq);
                  },
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            left: false,
            right: false,
            child: ChatMessageInput(
              controller: _controller,
              onPickImage: _pickImage,
              onSend: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAfterSendChatMessage(ChatMessageModel chat) {
    _controller.clear();
    _scrollBottom();
  }

  void _sendMessage([ChatMessageModel? chat]) {
    if (chat == null) {
      final text = _controller.text.trim();
      if (text.isEmpty) return;

      chat = ChatMessageModel(
        message: text,
        chatRoomSeq: widget.chatRoomSeq,
        fileFlag: 'N',
      );
    }

    _chatMessageProvider?.sendChatMessage(chat);
    _handleAfterSendChatMessage(chat);
  }

  Future<void> _sendFile(XFile imageFile) async {
    final fileModel = await _chatMessageProvider?.sendFile(imageFile);
    if (fileModel != null && fileModel.path != null) {
      final chat = ChatMessageModel(
        message: "${fileModel.path}/${fileModel.encodedName}",
        chatRoomSeq: widget.chatRoomSeq,
        fileFlag: 'Y',
      );
      _sendMessage(chat);
    }
  }

  void _scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      await _sendFile(pickedImage);
    }
  }
}

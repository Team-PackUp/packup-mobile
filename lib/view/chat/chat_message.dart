import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/provider/chat/chat_message_provider.dart';
import 'package:packup/model/chat/chat_message_model.dart';
import 'package:packup/widget/chat/chat_message_input.dart';
import 'package:provider/provider.dart';
import 'package:packup/model/common/file_model.dart';
import 'package:packup/widget/common/custom_appbar.dart';
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

class _ChatMessageContentState extends State<ChatMessageContent> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  late ChatMessageProvider _chatMessageProvider;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _controller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _chatMessageProvider = context.read<ChatMessageProvider>();
    });
  }

  static const double _threshold = 200.0;
  bool _isPaginating = false;

  void _scrollListener() async {
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position;

    final bool nearTop = pos.pixels >= (pos.maxScrollExtent - _threshold);

    if (!nearTop || _isPaginating || _chatMessageProvider.isLoading) {
      return;
    }

    _isPaginating = true;
    try {
      await getChatMessageMore();
    } finally {
      _isPaginating = false;
    }
  }
  getChatMessageMore() async {
    _chatMessageProvider.getMessage(widget.chatRoomSeq);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _chatMessageProvider = context.watch<ChatMessageProvider>();

    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppbar(
        title: widget.title,
        profile: CircleProfileImage(radius: screenH * 0.02),
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

  void _handleAfterSendChatMessage(chat) {
    _controller.clear();
    _scrollBottom();
  }

  void _sendMessage([ChatMessageModel? chat]) {
    if (chat == null) {
      if (_controller.text.isEmpty) return;

      chat = ChatMessageModel(
        message: _controller.text,
        chatRoomSeq: widget.chatRoomSeq,
        fileFlag: 'N',
      );
    }

    _chatMessageProvider.sendChatMessage(chat);
    _handleAfterSendChatMessage(chat);
  }

  void _sendFile(XFile imageFile) async {
    FileModel fileModel = await _chatMessageProvider.sendFile(imageFile);
    if (fileModel.path != null) {
      final chat = ChatMessageModel(
        message: "${fileModel.path}/${fileModel.encodedName}",
        chatRoomSeq: widget.chatRoomSeq,
        fileFlag: 'Y',
      );

      _sendMessage(chat);
    }
  }

  void _scrollBottom() {
    // 스크롤 가장 아래로
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      _sendFile(pickedImage);
    }
  }
}

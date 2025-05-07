import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/provider/chat/chat_message_provider.dart';
import 'package:packup/provider/chat/chat_room_provider.dart';
import 'package:packup/service/chat/chat_service.dart';
import 'package:packup/widget/chat/bubble_message.dart';
import 'package:packup/const/color.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';
import 'package:provider/provider.dart';

import '../../service/chat/socket_service.dart';

class ChatMessage extends StatelessWidget {
  final int chatRoomSeq;
  final int userSeq;

  const ChatMessage({
    super.key,
    required this.chatRoomSeq,
    required this.userSeq,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatMessageProvider()),
      ],
      child: ChatMessageContent(
        chatRoomSeq: chatRoomSeq,
        userSeq: userSeq,
      ),
    );
  }
}


class ChatMessageContent extends StatefulWidget {
  final int chatRoomSeq;
  final int userSeq;

  const ChatMessageContent({
    super.key,
    required this.chatRoomSeq,
    required this.userSeq,
  });

  @override
  _ChatMessageContentState createState() => _ChatMessageContentState();
}

class _ChatMessageContentState extends State<ChatMessageContent> {
  SocketService socketService = SocketService();
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  late final ChatMessageProvider chatMessageProvider;
  final ImagePicker _picker = ImagePicker();

  @override
  initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _controller = TextEditingController();

    socketService.initConnect(widget.chatRoomSeq); // STOMP 소켓 연결

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      chatMessageProvider = context.read<ChatMessageProvider>();
      await chatMessageProvider.getMessage(widget.chatRoomSeq);

      socketService.setMessageProvider(chatMessageProvider);
      socketService.initConnect(widget.chatRoomSeq);
    });
  }

  _scrollListener() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {}
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('채팅', style: TextStyle(color: TEXT_COLOR_W)),
          backgroundColor: PRIMARY_COLOR,
          iconTheme: IconThemeData(color: TEXT_COLOR_W),
        ),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Consumer<ChatMessageProvider>(
                    builder: (context, chatProvider, child) {
                      List<ChatMessageModel> filteredChatMessage = chatProvider.chatMessage;
                      
                      return ListView.separated(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.02,
                            bottom: MediaQuery.of(context).size.height * 0.02
                        ),
                        controller: _scrollController,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return BubbleMessage(
                            message: filteredChatMessage[index].message!,
                            userSeq: widget.userSeq,
                            sender: filteredChatMessage[index].userSeq!,
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        itemCount: filteredChatMessage.length,
                      );
                    },
                  ),
                ),
              ),
            ),
            sendMessage(),
          ],
        ),
      );
  }

  Widget sendMessage() => Container(
    height: MediaQuery.of(context).size.height * 0.1,
    padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.01,
        right: MediaQuery.of(context).size.width * 0.01,
        bottom: MediaQuery.of(context).size.height * 0.01
    ),
    child: Row(
      children: [
        IconButton(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt),
          color: PRIMARY_COLOR,
          iconSize: 25,
        ),
        Expanded(
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: _controller,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                color: PRIMARY_COLOR,
                iconSize: 25,
              ),
              hintText: "",
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10,
              ),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.grey, width: 0.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.grey, width: 0.2),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final chat = ChatMessageModel(
        message: _controller.text,
        chatRoomSeq: widget.chatRoomSeq,
      );

      socketService.sendMessage(chat);
      _controller.clear();

      scrollBottom();
    }
  }

  void _sendImage(XFile imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    chatMessageProvider.sendImage(imageFile);
    _controller.clear();

    scrollBottom();
  }


  void scrollBottom() {
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
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _sendImage(pickedImage);
    }
  }
}

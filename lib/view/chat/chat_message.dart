import 'dart:async';
import 'package:flutter/material.dart';
import 'package:packup/provider/chat/chat_provider.dart';
import 'package:packup/service/chat/chat_service.dart';
import 'package:packup/widget/chat/bubble_message.dart';
import 'package:packup/const/color.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';
import 'package:provider/provider.dart';

import '../../provider/search_bar/custom_search_bar_provider.dart';

class ChatMessage extends StatefulWidget {
  final int chatRoomSeq;
  final int userSeq;

  const ChatMessage({
    super.key,
    this.userSeq = 1,
    required this.chatRoomSeq,
  });

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  ChatService chatService = ChatService();
  ChatProvider chatProvider = ChatProvider();
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _controller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatService.initConnect(); // STOMP 소켓 연결
      // chatService.subscribe((ChatMessageModel message) {
      //   context.read<ChatProvider>().addMessage(message);
      // });
    });
  }

  _scrollListener() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
    }
  }

  @override
  void dispose() {
    chatService.disconnect();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => SearchBarProvider()),
      ],
      child: Scaffold(
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
                  child: Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      if (chatProvider.chatMessage.isEmpty && chatProvider.isLoading == false) {
                        chatProvider.getMessage(widget.chatRoomSeq);
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        controller: _scrollController,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return BubbleMessage(
                            message: chatProvider.chatMessage[index].message ?? '',
                            sender: chatProvider.chatMessage[index].sender ?? 0,
                            userSeq: widget.userSeq,
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: chatProvider.chatMessage.length,
                      );
                    },
                  ),
                ),
              ),
            ),
            sendMessage(),
          ],
        ),
      ),
    );
  }

  Widget sendMessage() => Container(
    height: MediaQuery.of(context).size.height * 0.1,
    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
    child: Row(
      children: [
        IconButton(
          onPressed: _sendMessage,
          icon: const Icon(Icons.camera_alt),
          color: PRIMARY_COLOR,
          iconSize: 25,
        ),
        const SizedBox(width: 10),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
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
        sender: widget.userSeq,
        chatRoomSeq: widget.chatRoomSeq,
        createdAt: null,
      );

      chatService.sendMessage(chat);
      // context.read<ChatProvider>().addMessage(chat);

      _controller.clear();

      // 스크롤 가장 아래로
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }
}

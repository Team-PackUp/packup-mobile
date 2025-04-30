import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:packup/provider/chat/chat_provider.dart';
import 'package:packup/service/chat/chat_service.dart';
import 'package:packup/Common/util.dart';
import 'package:packup/widget/chat/bubble_message.dart';
import 'package:packup/const/color.dart';
import 'package:packup/model/chat/ChatMessageModel.dart';

import 'package:packup/model/common/result_model.dart';

class ChatMessage extends StatefulWidget {
  final int chatRoomSeq;
  final int userSeq;

  const ChatMessage({
    super.key,
    this.chatRoomSeq = 2,
    this.userSeq = 1,
  });

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  ChatService chatService = ChatService();

  ChatProvider chatProvider = ChatProvider();

  late final TextEditingController _controller;
  late final ScrollController scrollController;
  List<ChatMessageModel> messages = [];

  StreamSubscription? messageSubscription;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dataSetting();

      chatService.initConnect(); // STOMP 소켓 연결
    });
  }

  Future<void> dataSetting() async {
    // List<ChatMessageModel> chatMessageList = await chatProvider.getMessage(widget.chatRoomSeq);
    //
    // if (chatMessageList.isNotEmpty) {
    //   setState(() {
    //     messages = chatMessageList;
    //   });
    // }
  }

  @override
  void dispose() {
    messageSubscription?.cancel();
    chatService.disconnect();
    _controller.dispose();
    scrollController.dispose();
    super.dispose();
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
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  controller: scrollController,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return BubbleMessage(
                      message: messages[index].message,
                      sender: messages[index].sender,
                      userSeq: widget.userSeq,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: messages.length,
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

      _controller.clear();
    }
  }

  void processReceivedData(ChatMessageModel data) {
    setState(() {
      messages.insert(0, data);
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}

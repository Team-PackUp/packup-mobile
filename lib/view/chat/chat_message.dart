import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:packup/service/chat/chat_service.dart';
import 'package:provider/provider.dart';
import 'package:packup/Common/util.dart';
import 'package:packup/provider/chat/chat_provider.dart';
import 'package:packup/widget/chat/bubble_message.dart';
import 'package:packup/const/color.dart';
import 'package:packup/model/chat/ChatModel.dart';

import '../../model/common/result_model.dart';

class ChatMessage extends StatefulWidget {
  final int chatRoomId;

  const ChatMessage({
    super.key,
    this.chatRoomId = 1,
  });

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  ChatService chatService = ChatService();

  late final TextEditingController _controller;
  late final ScrollController scrollController;
  List<ChatModel> messages = [];
  late int userSeq;

  StreamSubscription? messageSubscription;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dataSetting();
    });
  }

  Future<void> dataSetting() async {
    ResultModel resultModel = await chatService.getMessage(widget.chatRoomId);
    List<ChatModel> getMessage = resultModel.response;

    if (getMessage.isNotEmpty) {
      setState(() {
        messages = getMessage;
      });
    }

    chatService.connectWebSocket(widget.chatRoomId!);
    messageSubscription = chatService.messageStream.listen((event) {
      if (event is String) {
        try {
          Map<String, dynamic> jsonMap = jsonDecode(event);
          ChatModel data = ChatModel.fromJson(jsonMap);
          if (data.sender > 0) {
            processReceivedData(data);
          }
        } catch (e) {
          logger('채팅 수신 실패', 'ERROR');
        }
      }
    });
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
                      userSeq: userSeq,
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
      final chat = ChatModel(
        message: _controller.text,
        sender: userSeq,
        chatRoomId: widget.chatRoomId!,
      );
      chatService.sendMessage(chat);

      _controller.clear();
    }
  }

  void processReceivedData(ChatModel data) {
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

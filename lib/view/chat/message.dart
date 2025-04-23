import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:packup/view/chat/chat_view_model.dart';
import 'package:packup/widget/chat/bubble_message.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:packup/const/color.dart';
import 'package:packup/model/chat/ChatModel.dart';

class Message extends StatefulWidget {
  final int? chatRoomId;

  const Message({
    Key? key,
    this.chatRoomId,
  }) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  late final TextEditingController _controller;
  late List<ChatModel> messages = [];
  late ScrollController scrollController;
  late final WebSocketChannel _channel;
  late final ChatViewModel provider;
  late final int userSeq;
  late final String token;
  final String socketPrefix = dotenv.env['SOCKET_URL']!;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _controller = TextEditingController();
    dataSetting();
  }

  void dataSetting() async {
    _channel = WebSocketChannel.connect(Uri.parse('$socketPrefix/ws/chat'));

    provider = context.read<ChatViewModel>();
    List<ChatModel> getMessage =
        await provider.getMessage(chatRoomId: widget.chatRoomId);

    // userSeq = await getUserSeq();
    // token = await getToken();

    if (getMessage.isNotEmpty) {
      setState(() {
        messages = getMessage;
      });
    }

    _channel.stream.listen((event) {
      if (event is String) {
        try {
          Map<String, dynamic> jsonMap = jsonDecode(event);
          ChatModel data = ChatModel.fromJson(jsonMap);
          if (data.sender > 0) {
            processReceivedData(data);
          }
        } catch (e) {
          print('Error parsing message: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          '채팅',
          style: TextStyle(color: TEXT_COLOR_W),
        ),
        backgroundColor: PRIMARY_COLOR,
        iconTheme: IconThemeData(color: TEXT_COLOR_W),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView.separated(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        controller: scrollController,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return BubbleMessage(
                            message: messages[index].message,
                            sender: messages[index].sender,
                            userSeq: userSeq,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 12,
                          );
                        },
                        itemCount: messages.length,
                      )
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
              padding: EdgeInsets.zero,
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
                textCapitalization: TextCapitalization.sentences,
                controller: _controller,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                    color: PRIMARY_COLOR,
                    iconSize: 25,
                  ),
                  hintText: "",
                  hintMaxLines: 1,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  hintStyle: const TextStyle(
                    fontSize: 16,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 0.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

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

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      Map<String, dynamic> newMessage = {
        'message': _controller.text,
        'sender': userSeq,
        'jwtToken': token,
        'chatRoomId': widget.chatRoomId,
      };
      String jsonString = jsonEncode(newMessage);
      _channel.sink.add(jsonString); // 채팅 룸으로 전송

      _controller.text = '';
    }
  }
}

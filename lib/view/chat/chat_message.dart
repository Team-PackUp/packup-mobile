import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/model/chat/chat_read_model.dart';
import 'package:packup/provider/chat/chat_message_provider.dart';
import 'package:packup/widget/chat/message_box.dart';
import 'package:packup/const/color.dart';
import 'package:packup/model/chat/chat_message_model.dart';
import 'package:provider/provider.dart';

import 'package:packup/model/common/file_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:packup/provider/chat/chat_room_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Common/util.dart';
import '../../widget/chat/date_separator.dart';

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
  late ChatRoomProvider _chatRoomProvider;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _controller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _chatMessageProvider = context.read<ChatMessageProvider>();
      _chatRoomProvider = context.read<ChatRoomProvider>();

      await _chatMessageProvider.getMessage(widget.chatRoomSeq);
      _chatMessageProvider.subscribeChatMessage(widget.chatRoomSeq);
    });

  }

  _scrollListener() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      if (_chatMessageProvider.isLoading) return;
      getChatMessageMore();
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

    _chatMessageProvider.unSubscribeChatMessage(widget.chatRoomSeq);
  }

  @override
  Widget build(BuildContext context) {
    _chatMessageProvider = context.watch<ChatMessageProvider>();

    final messageList = _buildMessageListWithDateSeparators(_chatMessageProvider.chatMessage);

    return Scaffold(
      appBar: CustomAppbar(
        title: widget.title,
        trailing: CircleAvatar(
          radius: MediaQuery.of(context).size.height * 0.02,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.02,
                    right: MediaQuery.of(context).size.width * 0.02,
                    bottom: MediaQuery.of(context).size.height * 0.02,
                  ),
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    final item = messageList[index];

                    if (item is DateTime) {
                      return DateSeparator(dateText: convertToYmd(item));
                    }

                    final ChatMessageModel message = item;
                    final isLatestMessage = index == 0;

                    Widget messageWidget = MessageBox(
                      message: message.message!,
                      createTime: convertToHm(message.createdAt!),
                      userSeq: widget.userSeq,
                      sender: message.userSeq!,
                      fileFlag: message.fileFlag!,
                    );

                    if (isLatestMessage) {
                      messageWidget = VisibilityDetector(
                        key: Key('last-message-${message.seq}'),
                        onVisibilityChanged: (info) {
                          bool readChatMessage = _chatMessageProvider.lastReadMessageSeq! < message.seq! ||
                              _chatMessageProvider.lastReadMessageSeq! == 0;
                          if (info.visibleFraction > 0.8 && readChatMessage) {
                            ChatReadModel chatReadModel = ChatReadModel(
                              chatRoomSeq: widget.chatRoomSeq,
                              lastReadMessageSeq: message.seq!,
                            );
                            _chatMessageProvider.readChatMessage(chatReadModel);
                            _chatRoomProvider.readMessageThisRoom(widget.chatRoomSeq);
                          }
                        },
                        child: messageWidget,
                      );
                    }

                    return messageWidget;
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
          color: SELECTED,
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
                color: SELECTED,
                iconSize: 25,
              ),
              hintText: "메시지 입력...",
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<dynamic> _buildMessageListWithDateSeparators(List<ChatMessageModel> messages) {
    final List<dynamic> result = [];
    DateTime? lastDate;

    for (var message in messages) {
      final currentDate = message.createdAt!;
      if (lastDate == null || !isSameDate(lastDate, currentDate)) {
        result.add(currentDate);
        lastDate = currentDate;
      }
      result.add(message);
    }

    return result;
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
          fileFlag: 'Y'
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
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _sendFile(pickedImage);
    }
  }
}

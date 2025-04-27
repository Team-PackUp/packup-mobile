import 'package:flutter/material.dart';
import 'package:packup/provider/chat/chat_provider.dart';
import 'package:packup/widget/chat/chat_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: const ChatMessage(),
    );
  }
}

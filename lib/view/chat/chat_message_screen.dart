import 'package:flutter/material.dart';
import 'package:packup/provider/chat/chat_provider.dart';
import 'package:provider/provider.dart';
import 'chat_message.dart';

class ChatMessageScreen extends StatelessWidget {
  const ChatMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: const ChatMessage(),
    );
  }
}

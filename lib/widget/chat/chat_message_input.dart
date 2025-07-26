import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChatMessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPickImage;
  final VoidCallback onSend;
  final Color selectedColor;

  const ChatMessageInput({
    super.key,
    required this.controller,
    required this.onPickImage,
    required this.onSend,
    this.selectedColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {

    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Container(
      height: screenH * 0.1,
      padding: EdgeInsets.only(
        left: screenW * 0.01,
        right: screenW * 0.01,
        bottom: screenH * 0.01,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPickImage,
            icon: Transform.rotate(
              angle: math.pi / 4,
              child: const Icon(Icons.attach_file_rounded),
            ),
            color: selectedColor,
            iconSize: 25,
          ),
          Expanded(
            child: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: onSend,
                  icon: const Icon(Icons.send),
                  color: selectedColor,
                  iconSize: 25,
                ),
                hintText: '메시지 입력...',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenW * 0.02,
                  vertical: screenH * 0.01,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

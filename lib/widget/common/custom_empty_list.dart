import 'package:flutter/material.dart';

class CustomEmptyList extends StatelessWidget {
  final IconData icon;
  final String message;
  final double iconSize;
  final Color iconColor;
  final TextStyle? messageStyle;

  const CustomEmptyList({
    super.key,
    required this.message,
    required this.icon,
    this.iconSize = 64,
    this.iconColor = Colors.grey,
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          SizedBox(height: screenH * 0.02),
          Text(
            message,
            style: messageStyle ??
                theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

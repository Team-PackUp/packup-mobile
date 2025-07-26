import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷용

class DateSeparator extends StatelessWidget {
  final String dateText;

  const DateSeparator({
    super.key,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: screenH * 0.02
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenW * 0.1,
              vertical: screenH * 0.01
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(screenW * 0.04),
          ),
          child: Text(
            dateText,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

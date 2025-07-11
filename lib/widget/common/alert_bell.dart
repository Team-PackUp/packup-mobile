import 'package:flutter/material.dart';

class AlertBell extends StatelessWidget {
  const AlertBell({
    super.key,
    required this.count,
    required this.onTap,
  });

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(
            Icons.notifications_none,
            size: MediaQuery.of(context).size.width * 0.1,
          ),
        ),

        // 배지
        if (count > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.02,
                  height: MediaQuery.of(context).size.height * 0.001,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

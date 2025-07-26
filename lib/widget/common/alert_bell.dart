import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/alert_center/alert_center_provider.dart';

class AlertBell extends StatelessWidget {
  const AlertBell({super.key});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    final count = context.watch<AlertCenterProvider>().alertCount;
    final iconSize = MediaQuery.of(context).size.width * 0.07;

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () {
            context.push('/alert_center');
          },
          icon: Icon(
            Icons.notifications_none,
            size: iconSize,
          ),
        ),

        if (count > 0)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenW * 0.015,
                  vertical: screenH * 0.003
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

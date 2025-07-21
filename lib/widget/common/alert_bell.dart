import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/alert_center/alert_center_provider.dart';

class AlertBell extends StatelessWidget {
  const AlertBell({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
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

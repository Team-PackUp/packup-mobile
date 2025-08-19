import 'package:flutter/material.dart';

class SwitchModeBar extends StatelessWidget {
  const SwitchModeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 48,
        child: ElevatedButton.icon(
          onPressed: () {
            // TODO: 모드 전환 (Guide → User)
          },
          icon: const Icon(Icons.sync_rounded, size: 18),
          label: const Text('투어 모드로 전환'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            elevation: 0,
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

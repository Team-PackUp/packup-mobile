import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:packup/model/common/app_mode.dart';
import 'package:packup/provider/common/app_mode_provider.dart';

class SwitchModeBar extends StatefulWidget {
  const SwitchModeBar({super.key});

  @override
  State<SwitchModeBar> createState() => _SwitchModeBarState();
}

class _SwitchModeBarState extends State<SwitchModeBar> {
  bool _busy = false;

  Future<void> _switchToTourMode() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await context.read<AppModeProvider>().setMode(AppMode.user);

      if (!mounted) return;
      context.go('/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모드 전환에 실패했습니다. 다시 시도해주세요.')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 48,
        child: ElevatedButton.icon(
          onPressed: _busy ? null : _switchToTourMode,
          icon:
              _busy
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(Icons.sync_rounded, size: 18),
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

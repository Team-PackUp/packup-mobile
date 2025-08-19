import 'package:flutter/material.dart';
import 'package:packup/widget/menu/switch_mode_bar.dart';

class MenuSwitchModeSection extends StatelessWidget {
  const MenuSwitchModeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SwitchModeBar(),
    );
  }
}

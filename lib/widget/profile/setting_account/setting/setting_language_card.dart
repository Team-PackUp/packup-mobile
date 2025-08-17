import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  const LanguageCard({
    super.key,
    required this.code,
    required this.label,
    required this.groupValue,
    required this.onChanged,
    this.activeColor,
  });

  final String code;
  final String label;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: RadioListTile<String>(
        value: code,
        groupValue: groupValue,
        onChanged: (v) => onChanged(v!),
        title: Text(label, style: const TextStyle(fontSize: 16)),
        activeColor: activeColor ?? cs.primary,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}

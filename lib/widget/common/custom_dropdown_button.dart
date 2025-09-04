import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDropdownButton<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final double borderRadius;
  final Color dropdownColor;
  final TextStyle? style;
  final bool isDense;
  final Widget? icon;

  const AppDropdownButton({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.borderRadius = 12,
    this.dropdownColor = Colors.white,
    this.style,
    this.isDense = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        isDense: isDense,
        borderRadius: BorderRadius.circular(borderRadius),
        dropdownColor: dropdownColor,
        style: style ?? const TextStyle(fontSize: 14, color: Colors.black),
        icon: icon ?? const Icon(Icons.arrow_drop_down, color: Colors.black),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

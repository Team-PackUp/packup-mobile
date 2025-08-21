import 'package:flutter/material.dart';

class YearsRoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const YearsRoundButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Icon(icon),
      ),
    );
  }
}

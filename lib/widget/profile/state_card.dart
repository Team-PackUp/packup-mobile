import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final double w;
  final double h;

  const StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(w * 0.03),
      ),
      child: Column(
        children: [
          Icon(icon, size: w * 0.07, color: Colors.pink),
          SizedBox(height: h * 0.01),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.04)),
          Text(label, style: TextStyle(fontSize: w * 0.03)),
        ],
      ),
    );
  }
}
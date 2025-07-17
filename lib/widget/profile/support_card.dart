import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SupportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double w;
  final double h;

  const SupportCard({
    required this.icon,
    required this.title,
    required this.subtitle,
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
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: w * 0.06),
          SizedBox(width: w * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.04)),
                SizedBox(height: h * 0.004),
                Text(subtitle,
                    style: TextStyle(fontSize: w * 0.03, color: Colors.grey)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: w * 0.05),
        ],
      ),
    );
  }
}
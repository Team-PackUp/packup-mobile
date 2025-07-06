import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
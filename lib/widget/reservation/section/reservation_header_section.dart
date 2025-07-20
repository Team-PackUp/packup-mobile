import 'package:flutter/material.dart';

class ReservationHeaderSection extends StatelessWidget {
  const ReservationHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '시간 선택',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    '게스트 1명',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Row(
                children: [
                  _CountButton(icon: Icons.remove, onPressed: () {}),
                  const SizedBox(width: 12),
                  const Text(
                    '1',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  _CountButton(icon: Icons.add, onPressed: () {}),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CountButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}

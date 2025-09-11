import 'package:flutter/material.dart';
import 'package:packup/provider/tour/reservation/reservation_provider.dart';
import 'package:provider/provider.dart';

class ReservationHeaderSection extends StatelessWidget {
  const ReservationHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ReservationProvider>();
    final canDec = p.guestCount > 1;
    final canInc =
        p.selected == null
            ? true
            : p.guestCount <
                (p.maxSelectableGuest == 0 ? 1 : p.maxSelectableGuest);

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
              Text(
                '게스트 ${p.guestCount}명',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  _CountButton(
                    icon: Icons.remove,
                    enabled: canDec,
                    onPressed: p.decGuest,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${p.guestCount}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _CountButton(
                    icon: Icons.add,
                    enabled: canInc,
                    onPressed: p.incGuest,
                  ),
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
  final bool enabled;
  final VoidCallback onPressed;

  const _CountButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final border = enabled ? Colors.black87 : Colors.black26;
    final iconColor = enabled ? Colors.black87 : Colors.black26;

    return Ink(
      decoration: BoxDecoration(
        border: Border.all(color: border),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: enabled ? onPressed : null,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }
}

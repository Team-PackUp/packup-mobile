import 'package:flutter/material.dart';

class ReplyStarRating extends StatelessWidget {
  final int value; // 0~5
  final ValueChanged<int> onChanged;
  const ReplyStarRating({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final idx = i + 1;
        final filled = value >= idx;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => onChanged(idx),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_border_rounded,
              size: 34,
              color: filled ? Colors.amber : Colors.grey.shade400,
            ),
          ),
        );
      }),
    );
  }
}

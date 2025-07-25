import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';

class TourDescription extends StatelessWidget {
  final TourDetailModel tour;

  const TourDescription({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '설명',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Text(
          tour.description,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.access_time, size: 20, color: Colors.black54),
            const SizedBox(width: 8),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '소요 시간: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: tour.duration),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.language, size: 20, color: Colors.black54),
            const SizedBox(width: 8),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '언어: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: tour.languages.join(', ')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

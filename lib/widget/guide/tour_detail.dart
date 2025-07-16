import 'package:flutter/material.dart';

class TourDetail extends StatelessWidget {
  const TourDetail({super.key});

  @override
  Widget build(BuildContext context) {
    const highlights = [
      "Explore Gwangjang Market",
      "Taste authentic street food",
      "Visit a traditional tea house",
      "Learn about Korean culinary history",
    ];

    const itinerary = [
      "9:00 AM - Meet at Gwangjang Market entrance",
      "9:15 AM - Explore market stalls and sample street food",
      "11:00 AM - Visit a nearby traditional tea house",
      "12:00 PM - Walk through a local neighborhood",
      "1:00 PM - Tour ends near Jongmyo Shrine",
    ];

    const included = [
      "Food samples",
      "Tea ceremony experience",
      "Guide services",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tour Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        _buildSectionTitle("Highlights"),
        const SizedBox(height: 8),
        ...highlights.map(
          (text) => _IconBullet(text, icon: Icons.star, color: Colors.amber),
        ),

        const SizedBox(height: 20),
        _buildSectionTitle("Itinerary"),
        const SizedBox(height: 8),
        ...itinerary.map((text) => _DotBullet(text)),

        const SizedBox(height: 20),
        _buildSectionTitle("What's Included"),
        const SizedBox(height: 8),
        ...included.map(
          (text) => _IconBullet(text, icon: Icons.check, color: Colors.green),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
    );
  }
}

class _IconBullet extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const _IconBullet(this.text, {required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

class _DotBullet extends StatelessWidget {
  final String text;
  const _DotBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: CircleAvatar(radius: 2, backgroundColor: Colors.grey),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

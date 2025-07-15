import 'package:flutter/material.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:packup/widget/tour/tour_card.dart';
import 'package:provider/provider.dart';

class HotTourSection extends StatelessWidget {
  const HotTourSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TourProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🔥', style: TextStyle(fontSize: 18)),
              SizedBox(width: 6),
              Text(
                '인기 급상승 투어',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 350,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  provider.tourList.length + (provider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < provider.tourList.length) {
                  final tour = provider.tourList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.45,
                        ),
                        child: TourCard(
                          tour: tour,
                          isFavorite: false,
                          onTap: () {},
                          onFavoriteToggle: () {},
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TourListingEmptySection extends StatelessWidget {
  const TourListingEmptySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.edit_off, size: 96, color: Color(0xFFD1D5DB)),
            SizedBox(height: 16),
            Text(
              '시작된 리스팅이 아직 없습니다..',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              '리스팅을 등록하면 여기에 표시됩니다.',
              style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}

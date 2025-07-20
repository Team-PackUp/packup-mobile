import 'package:flutter/material.dart';
import 'package:packup/widget/reservation/time_slot_card.dart';

class ReservationTimeListSection extends StatelessWidget {
  const ReservationTimeListSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 날짜 및 시간 데이터
    final List<String> timeList = [
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '7월 25일 (목)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: timeList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                return TimeSlotCard(
                  time: timeList[index],
                  isSelected: index == 2, // 임시 선택 상태
                  onTap: () {
                    // TODO: 시간 선택 로직
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

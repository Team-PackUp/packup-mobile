import 'package:flutter/material.dart';
import 'package:packup/widget/reservation/time_card.dart';

class ReservationTimeListSection extends StatelessWidget {
  const ReservationTimeListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            '6월 2025',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          const TimeCard(
            dateText: '',
            time: '오전 11:30 ~ 오후 1:30',
            price: '₩55,000 1인당',
            subtitle: '프라이빗 예약 요금 이용 가능',
            remainText: '10자리 남음',
            isSelected: false,
          ),
          const SizedBox(height: 12),

          const TimeCard(
            dateText: '6월 24(화요일)',
            time: '오전 11:30 ~ 오후 1:30',
            price: '₩55,000 1인당',
            subtitle: '프라이빗 예약 요금 이용 가능',
            remainText: '10자리 남음',
            isSelected: true, // 선택된 상태
          ),
          const SizedBox(height: 12),

          const TimeCard(
            dateText: '6월 25(수요일)',
            time: '오전 11:30 ~ 오후 1:30',
            price: '₩55,000 1인당',
            subtitle: '프라이빗 예약 요금 이용 가능',
            remainText: '10자리 남음',
            isSelected: false,
          ),
          const SizedBox(height: 12),

          const TimeCard(
            dateText: '6월 26(수요일)',
            time: '오전 11:30 ~ 오후 1:30',
            price: '₩55,000 1인당',
            subtitle: '프라이빗 예약 요금 이용 가능',
            remainText: '10자리 남음',
            isSelected: false,
          ),
        ],
      ),
    );
  }
}

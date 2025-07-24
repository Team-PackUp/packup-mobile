import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:packup/view/reservation/reservation.dart';

class TourFooter extends StatelessWidget {
  const TourFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return const _ReservationModalWrapper();
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '지금 예약',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReservationModalWrapper extends StatelessWidget {
  const _ReservationModalWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.88,
              child: SafeArea(
                top: false,
                bottom: true, // ✅ 여기!
                child: ReservationPage(scrollController: ScrollController()),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

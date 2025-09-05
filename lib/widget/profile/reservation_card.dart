import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/common/slide_text.dart';
import '../../Common/util.dart';
import '../../model/tour/tour_model.dart';

class ReservationCard extends StatelessWidget {
  final TourModel tour;
  final double w;
  final double h;

  const ReservationCard({
    super.key,
    required this.tour,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    final image = tour.titleImagePath ?? 'assets/image/logo/logo.png';
    final title = tour.tourTitle ?? "";
    final date = tour.tourStartDate;
    final guide = tour.guide?.guideName ?? '가이드 미지정';
    final people = tour.remainPeople.toString();

    return GestureDetector(
      onTap: () => context.push('/tour/${tour.seq}'),
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.02),
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(w * 0.03),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideText(
              title: title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.045),
            ),
            SizedBox(height: h * 0.02),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이미지 + 정보
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          fullFileUrl(image),
                          width: w * 0.25,
                          height: h * 0.1,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Image.asset('assets/image/logo/logo.png',
                                  width: w * 0.25,
                                  height: h * 0.1,
                                  fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: w * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                SizedBox(height: h * 0.01),
                                // Text(convertToYmd(date!), style: TextStyle(fontSize: w * 0.035)),
                              ],
                            ),
                            SizedBox(height: h * 0.01),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 16),
                                SizedBox(height: w * 0.01),
                                Text('가이드: $guide', style: TextStyle(fontSize: w * 0.035)),
                              ],
                            ),
                            SizedBox(height: h * 0.01),
                            Row(
                              children: [
                                const Icon(Icons.people_outline, size: 16),
                                SizedBox(height: w * 0.02),
                                Text('남은 인원 $people명', style: TextStyle(fontSize: w * 0.035)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    _actionButton(context, Icons.close, '취소', () {
                      // 취소 처리
                    }),
                    SizedBox(height: h * 0.01),
                    _actionButton(context, Icons.chat_bubble_outline, '채팅', () {
                      // 채팅 처리
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
      BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: w * 0.035),
      label: Text(label, style: TextStyle(fontSize: w * 0.035)),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.02),
        minimumSize: Size(w * 0.01, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ).copyWith(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}

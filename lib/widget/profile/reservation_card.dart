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
    final statusCode = tour.tourStatusCode;
    final statusLabel = tour.tourStatusLabel;
    final reviewFlag = tour.reviewFlag;

    return Container(
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
                    _statusLabel(context, statusCode!, statusLabel!),
                  ],
                ),
              ],
            ),
            if ((statusCode ?? '') == '100003' && !reviewFlag!) ...[
              // 이미 후기 등록 했는지 추가 검증 필요
              SizedBox(height: h * 0.015),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push('/reply_write/${tour.seq}/REPLY_TOUR');
                  },
                  icon: Icon(Icons.edit, size: w * 0.05),
                  label: Text(
                    '후기 작성',
                    style: TextStyle(fontSize: w * 0.04, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: h * 0.018),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ).copyWith(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
            ]
          ],
        ),
    );
  }

  Widget _statusLabel(
      BuildContext context,
      String statusCode,
      String statusLabel,
      ) {

    late Color bg;
    late Color fg;
    late Color bd;
    late IconData statusIcon;

    switch (statusCode) {
      case '100001':
        bg = Colors.green.withOpacity(0.10);
        fg = Colors.green.shade700;
        bd = Colors.green.shade300;
        statusIcon = Icons.event_available;
        break;

      case '100002':
        bg = Colors.orange.withOpacity(0.10);
        fg = Colors.orange.shade800;
        bd = Colors.orange.shade300;
        statusIcon = Icons.hourglass_bottom;
        break;

      case '100003':
        bg = Colors.grey.shade200;
        fg = Colors.grey.shade600;
        bd = Colors.grey.shade300;
        statusIcon = Icons.event_busy;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.012),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: w * 0.035, color: fg),
          SizedBox(width: w * 0.01),
          Text(
            statusLabel,
            style: TextStyle(
              fontSize: w * 0.035,
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/model/tour/tour_model.dart';
import '../../common/util.dart';
import '../common/slide_text.dart';
import '../../common/size_config.dart'; // <- SizeConfig & ContextSizeX 확장

class HotTourCard extends StatelessWidget {
  const HotTourCard({super.key, required this.tour});
  final TourModel tour;

  @override
  Widget build(BuildContext context) {
    final hPad = context.sX(16, minScale: .85, maxScale: 1.2);
    final vPad = context.sY(20, minScale: .85, maxScale: 1.2);
    final chipHPad = context.sX(8, minScale: .85, maxScale: 1.2);
    final chipVPad = context.sY(6, minScale: .85, maxScale: 1.2);
    final gapXs = context.sX(6, minScale: .85, maxScale: 1.2);
    final gapSm = context.sY(4, minScale: .85, maxScale: 1.2);
    final gapMd = context.sY(5, minScale: .85, maxScale: 1.2);
    final avatarR = context.sX(18, minScale: .9, maxScale: 1.15);
    final iconSize = context.sX(14, minScale: .9, maxScale: 1.2);
    final corner = context.sX(12, minScale: .9, maxScale: 1.2);

    double f(double base) => (base * context.textScale.clamp(1.0, 1.2));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(corner)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 6 / 3,
                child: Image.network(
                  fullFileUrl(tour.titleImagePath ?? ''),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/image/logo/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (tour.remainPeople <= 3)
                Positioned(
                  top: gapSm,
                  right: gapSm,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: chipHPad,
                      vertical: chipVPad,
                    ),
                    decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '마감 임박! (${tour.remainPeople}자리 남음)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: f(10),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // 본문
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle.merge(
                  style: TextStyle(
                    fontSize: f(14), // 제목 기본 크기
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  child: SlideText(title: tour.tourTitle ?? ''),
                ),

                SizedBox(height: gapMd),

                // 장소
                Row(
                  children: [
                    Icon(Icons.place, size: iconSize, color: Colors.grey),
                    SizedBox(width: gapXs),
                    Expanded(
                      child: Text(
                        tour.tourLocation ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: f(11),
                          color: Colors.grey[700],
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: gapSm),

                // 가격
                Text(
                  tour.tourPrice != null
                      ? formatPrice(tour.tourPrice!)
                      : '가격 문의',
                  style: TextStyle(
                    fontSize: f(15),
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                    height: 1.2,
                  ),
                ),

                SizedBox(height: gapSm),

                // 가이드
                Row(
                  children: [
                    CircleAvatar(
                      radius: avatarR,
                      backgroundImage: NetworkImage(
                        fullFileUrl(tour.guideModel?.guideAvatarPath ?? ''),
                      ),
                      onBackgroundImageError: (_, __) {},
                      backgroundColor: Colors.grey[200],
                    ),
                    SizedBox(width: gapMd),
                    Expanded(
                      child: Text(
                        tour.guideModel?.guideName ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: f(11),
                          color: Colors.grey[700],
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../common/size_config.dart';
import '../../provider/alert_center/alert_center_provider.dart';

class AlertBell extends StatelessWidget {
  const AlertBell({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<AlertCenterProvider>().alertCount;

    // 균형 스케일 + 상/하한 (앱바 액션 규격과 동일)
    double s0(double dp, {double min = 0.95, double max = 1.15}) {
      final s = context.scaleBalanced.clamp(min, max);
      return dp * s;
    }

    final box      = s0(44);   // 액션 터치 영역(정사각)
    final iconSize = s0(25);   // 아이콘 크기
    final badgeHP  = s0(4);    // 배지 내부 좌우 패딩
    final badgeVP  = s0(2);    // 배지 내부 상하 패딩
    final badgeR   = s0(10);   // 배지 라운드
    // 종 아이콘은 시각 중심이 아래라 살짝 올려 보정
    final bellYOffset = -context.sY(1, minScale: 1, maxScale: 1);
    // 배지 위치(슬롯 기준 상대값)
    final badgeTop  = box * 0.14;
    final badgeRight= box * 0.10;

    return SizedBox(
      width: box,
      height: box,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 기본 제약 제거한 IconButton
          IconButton(
            onPressed: () => context.push('/alert_center'),
            icon: const Icon(Icons.notifications_none),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),


          // 옵티컬 보정(아이콘 살짝 위로)
          Positioned.fill(
            child: IgnorePointer(
              child: Transform.translate(
                offset: Offset(0, bellYOffset),
                child: const SizedBox.shrink(), // 아이콘은 위 IconButton이 그림
              ),
            ),
          ),

          if (count > 0)
            Positioned(
              top: badgeTop,
              right: badgeRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: badgeHP, vertical: badgeVP),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(badgeR),
                ),
                constraints: BoxConstraints(minWidth: s0(18), minHeight: s0(16)),
                alignment: Alignment.center,
                child: Text(
                  count > 99 ? '99+' : '$count',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: s0(10),
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

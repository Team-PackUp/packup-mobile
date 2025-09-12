import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/view/payment/toss/toss_payment_page.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/reservation/reservation_provider.dart';
import 'package:packup/provider/user/user_provider.dart';

class ReservationConfirmPage extends StatelessWidget {
  const ReservationConfirmPage({super.key});
  static const double _payBarHeight = 88;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ReservationProvider>();
    final s = p.selected;
    final canPay = s != null && p.guestCount > 0 && p.remaining > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '확인 및 결제',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  24 + _payBarHeight + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── 상단 요약 카드
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 썸네일 + 타이틀 + 평점
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _TitleLine(),
                              SizedBox(height: 6),
                              _RatingLine(),
                            ],
                          ),

                          const _DividerInset(top: 16, bottom: 12),

                          // 날짜 / 시간
                          _InfoLine(
                            topChild: Text(
                              s == null ? '-' : _fullDate(s.startTime),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            bottomChild: Text(
                              s == null
                                  ? '-'
                                  : _timeRange(s.startTime, s.endTime),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          const _DividerInset(),
                          _InfoRow(label: '게스트', value: '성인 ${p.guestCount}명'),
                          const _DividerInset(),

                          // 전체 요금
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '전체 요금',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                s == null ? '-' : _price(p.totalPrice),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '이 예약은 환불되지 않습니다.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _Card(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(child: _PrivateUpsellText()),
                          const SizedBox(width: 12),
                          Builder(
                            builder: (context) {
                              final disabled =
                                  (s == null) || !p.supportsPrivate;
                              return IgnorePointer(
                                ignoring: disabled,
                                child: Opacity(
                                  opacity: disabled ? .5 : 1,
                                  child: Checkbox(
                                    value: p.isPrivate,
                                    onChanged:
                                        (v) => context
                                            .read<ReservationProvider>()
                                            .setPrivate(v ?? false),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // (결제 수단 카드 제거)
                  ],
                ),
              ),
            ),
          ),

          // ── 하단 스티키 결제 바
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _PayBar(
              enabled: canPay,
              totalPrice: p.totalPrice,
              onPay: () => _onPay(context),
            ),
          ),
        ],
      ),
    );
  }

  void _onPay(BuildContext context) async {
    final p = context.read<ReservationProvider>();
    final s = p.selected;
    if (s == null) return;

    final orderId = 'ORDER_${DateTime.now().millisecondsSinceEpoch}';
    final orderName = p.tourTitle ?? '투어 예약';
    final amount = p.totalPrice;

    final userSeq = context.read<UserProvider>().userModel?.userId;

    final customerKey = "user_$userSeq";

    final result = await context.push(
      '/payment/toss',
      extra: TossPaymentArgs(
        orderId: orderId,
        orderName: orderName,
        amount: amount,
        customerKey: customerKey,
      ),
    );

    if (result is TossPaymentSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('결제가 완료되었습니다. 예약을 확정합니다.')));
      Navigator.pop(context);
    } else if (result is TossPaymentFail) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('결제 실패: ${result.message ?? '다시 시도해주세요.'}')),
      );
    }
  }
}

class _TitleLine extends StatelessWidget {
  const _TitleLine();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ReservationProvider>();
    return Text(
      p.tourTitle ?? '예약 정보',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}

class _RatingLine extends StatelessWidget {
  const _RatingLine();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.star_rate_rounded, size: 16, color: Colors.black87),
        SizedBox(width: 4),
        Text(
          '5.0 (9)',
          style: TextStyle(fontSize: 13, color: Color(0xFF6D6D72)),
        ),
      ],
    );
  }
}

/// 공통 카드
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class _DividerInset extends StatelessWidget {
  final double top;
  final double bottom;
  const _DividerInset({this.top = 12, this.bottom = 12});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final Widget topChild;
  final Widget bottomChild;
  const _InfoLine({required this.topChild, required this.bottomChild});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [topChild, const SizedBox(height: 6), bottomChild],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6D6D72)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivateUpsellText extends StatelessWidget {
  const _PrivateUpsellText();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ReservationProvider>();

    if (!p.supportsPrivate) {
      return const Text(
        '해당 체험은 프라이빗 예약을 지원하지 않습니다.',
        style: TextStyle(fontSize: 13, color: Color(0xFF6D6D72)),
      );
    }

    final shortfall = p.privateShortfall;
    final text =
        (shortfall > 0)
            ? '${_priceShort(shortfall)} 추가로 프라이빗 예약을 진행하세요. '
                '프라이빗 최소 요금을 충족하면 됩니다.'
            : '추가 요금 없이 프라이빗 예약이 가능합니다.';

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, height: 1.4),
        children: [
          const TextSpan(
            text: '내 일행만 참여하는 체험 예약하기\n',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF111111).withOpacity(.84),
            ),
          ),
        ],
      ),
    );
  }
}

class _PayBar extends StatelessWidget {
  final bool enabled;
  final int totalPrice;
  final VoidCallback onPay;

  const _PayBar({
    required this.enabled,
    required this.totalPrice,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E5EA))),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '결제 금액',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6D6D72)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _price(totalPrice),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: enabled ? onPay : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.black12,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('결제하기', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────── util ───────────

String _price(int v) {
  final s = v.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ',',
  );
  return '₩$s KRW';
}

String _priceShort(int v) {
  final s = v.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ',',
  );
  return '₩$s';
}

String _fullDate(DateTime d) {
  const w = ['월', '화', '수', '목', '금', '토', '일'];
  return '${d.year}년 ${d.month}월 ${d.day}일 ${w[d.weekday - 1]}요일';
}

String _timeRange(DateTime s, DateTime e) {
  String fmt(DateTime t) {
    final h = t.hour;
    final m = t.minute.toString().padLeft(2, '0');
    final am = h < 12 ? '오전' : '오후';
    final hh = h % 12 == 0 ? 12 : h % 12;
    return '$am $hh:$m';
  }

  return '${fmt(s)} - ${fmt(e)}';
}

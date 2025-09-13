import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';

import 'package:packup/provider/tour/reservation/reservation_provider.dart';

class PaymentCompleteScreen extends StatelessWidget {
  const PaymentCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;

    if (extra is Fail) {
      return _FailureView(fail: extra);
    }
    if (extra is! Success) {
      return const Scaffold(
        body: SafeArea(child: Center(child: Text('잘못된 접근입니다.'))),
      );
    }

    final params = extra.additionalParams ?? {};
    final title = params['title'] ?? params['orderName'] ?? '프로그램 이름';
    final dateStr = params['date'] ?? _formatToday();
    final selected =
        context.mounted ? context.read<ReservationProvider?>()?.selected : null;
    final time =
        selected != null
            ? _timeRange(selected.startTime, selected.endTime)
            : (params['time'] ?? '-');

    final amount = extra.amount.toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제 완료'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              // 상단 카드
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                      color: Colors.black.withOpacity(0.06),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 56,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '결제가 완료되었습니다',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    // 위치 행 제거, 날짜/시간만 노출
                    Row(
                      children: [
                        Expanded(child: _kvRow('날짜', dateStr)),
                        const SizedBox(width: 12),
                        // Expanded(child: _kvRow('시간', time)),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    Text(
                      _formatWon(amount),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Back to Home 버튼: 검은색 텍스트
              TextButton(
                onPressed: () => context.go('/home'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black, // <= 요청사항
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatWon(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(',');
    }
    return '${buf.toString()}원';
  }

  static String _formatToday() {
    final now = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${now.year}.${two(now.month)}.${two(now.day)}';
  }

  static String _timeRange(DateTime s, DateTime e) {
    String fmt(DateTime t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    return '${fmt(s)}-${fmt(e)}';
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.fail});
  final Fail fail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('결제 실패'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              const Icon(
                Icons.error_rounded,
                size: 56,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                '결제에 실패했습니다.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _errorRow('코드', fail.errorCode),
              const SizedBox(height: 8),
              _errorRow('메시지', fail.errorMessage),
              const SizedBox(height: 8),
              _errorRow('orderId', fail.orderId),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go('/home'),
                child: const Text('홈으로'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _errorRow(String k, String v) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 72,
        child: Text(k, style: const TextStyle(color: Colors.grey)),
      ),
      const SizedBox(width: 8),
      Expanded(child: Text(v)),
    ],
  );
}

Widget _kvRow(String k, String v) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 48,
        child: Text(k, style: const TextStyle(color: Colors.grey)),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';

/// 결제 완료 화면
/// - Success: 체크 아이콘 + 상품/위치/날짜/시간/금액 카드
/// - Fail: 실패 안내
/// 추가 정보는 result.additionalParams에서 받아옵니다.
///  - title : 상품/프로그램 이름 (예: "서울숲에서 즐기는 활력 충전 야외 요가")
///  - location : 위치 (예: "서울시 마포구")
///  - date : 날짜 (예: "2025.02.01")
///  - time : 시간 (예: "17:00-19:00")
class PaymentCompleteScreen extends StatelessWidget {
  const PaymentCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = GoRouterState.of(context).extra;

    if (result is Fail) {
      return _FailureView(fail: result);
    }
    if (result is! Success) {
      return const Scaffold(
        body: SafeArea(child: Center(child: Text('잘못된 접근입니다.'))),
      );
    }

    final params = result.additionalParams ?? {};
    final title = params['title'] ?? params['orderName'] ?? '프로그램 이름';
    final location = params['location'] ?? '위치 정보 없음';
    final date = params['date'] ?? '날짜 정보 없음';
    final time = params['time'] ?? '시간 정보 없음';
    final amount = result.amount.toInt();

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
              // 상단 완료 카드
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
                      spreadRadius: 0,
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
                    _kvRow('위치', location),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _kvRow('날짜', date)),
                        const SizedBox(width: 12),
                        Expanded(child: _kvRow('시간', time)),
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
              // 하단 버튼들
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
              // “결제내역 보러가기”는 요구사항상 제외
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

  Widget _errorRow(String k, String v) => Row(
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

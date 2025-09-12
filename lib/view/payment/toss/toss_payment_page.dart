import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
// (선택) dotenv 사용 시
// import 'package:flutter_dotenv/flutter_dotenv.dart';

/// ───── 결제 페이지 파라미터/결과 모델 ─────
class TossPaymentArgs {
  final String orderId;
  final String orderName;
  final int amount;
  final String customerKey;
  TossPaymentArgs({
    required this.orderId,
    required this.orderName,
    required this.amount,
    required this.customerKey,
  });
}

class TossPaymentSuccess {
  final String orderId;
  final String orderName;
  final int amount;
  TossPaymentSuccess({
    required this.orderId,
    required this.orderName,
    required this.amount,
  });
}

class TossPaymentFail {
  final String? message;
  TossPaymentFail({this.message});
}

/// ───── 결제 페이지 (GoRouter extra → 생성자 주입) ─────
class TossPaymentPage extends StatefulWidget {
  final TossPaymentArgs args;
  const TossPaymentPage({super.key, required this.args});

  @override
  State<TossPaymentPage> createState() => _TossPaymentPageState();
}

class _TossPaymentPageState extends State<TossPaymentPage> {
  late final PaymentWidget _paymentWidget;
  PaymentMethodWidgetControl? _methodCtl;
  AgreementWidgetControl? _agreeCtl;

  // (1) .env 사용 시: dotenv.env['TOSS_CLIENT_KEY']!
  // (2) --dart-define 사용 권장:
  //    flutter run --dart-define=TOSS_CLIENT_KEY=xxxx
  //    flutter build ... --dart-define=TOSS_CLIENT_KEY=xxxx
  String get _clientKey => const String.fromEnvironment(
    'TOSS_CLIENT_KEY',
    defaultValue: 'test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm', // 테스트 키
  );

  @override
  void initState() {
    super.initState();

    // 결제 위젯 인스턴스 생성 (args는 생성자 주입된 widget.args 사용)
    _paymentWidget = PaymentWidget(
      clientKey: _clientKey,
      customerKey: widget.args.customerKey,
    );

    // 결제수단/약관 위젯 렌더
    _paymentWidget
        .renderPaymentMethods(
          selector: 'methods',
          amount: Amount(
            value: widget.args.amount,
            currency: Currency.KRW,
            country: 'KR',
          ),
        )
        .then((c) => _methodCtl = c);

    _paymentWidget
        .renderAgreement(selector: 'agreement')
        .then((c) => _agreeCtl = c);
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                children: [
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 460,
                    child: PaymentMethodWidget(
                      paymentWidget: _paymentWidget,
                      selector: 'methods',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: AgreementWidget(
                      paymentWidget: _paymentWidget,
                      selector: 'agreement',
                    ),
                  ),

                  // PaymentMethodWidget(
                  //   paymentWidget: _paymentWidget,
                  //   selector: 'methods',
                  // ),

                  // const SizedBox(height: 12),
                  // AgreementWidget(
                  //   paymentWidget: _paymentWidget,
                  //   selector: 'agreement',
                  // ),
                ],
              ),
            ),
            _BottomBar(amount: args.amount, onPay: _onPay),
          ],
        ),
      ),
    );
  }

  Future<void> _onPay() async {
    try {
      final result = await _paymentWidget.requestPayment(
        paymentInfo: PaymentInfo(
          orderId: widget.args.orderId,
          orderName: widget.args.orderName,
          // successUrl / failUrl: 위젯 SDK에선 보통 콜백으로 처리하므로 불필요
          // 금액은 renderPaymentMethods에서 이미 설정
        ),
      );

      if (!mounted) return;

      if (result.success != null) {
        context.pop(
          TossPaymentSuccess(
            orderId: widget.args.orderId,
            orderName: widget.args.orderName,
            amount: widget.args.amount,
          ),
        );
      } else if (result.fail != null) {
        final msg =
            (result.fail as dynamic)?.errorMessage?.toString() ??
            result.fail.toString();
        context.pop(TossPaymentFail(message: msg));
      } else {
        context.pop(TossPaymentFail(message: '결과 해석 불가'));
      }
    } catch (e) {
      if (!mounted) return;
      context.pop(TossPaymentFail(message: '오류: $e'));
    }
  }
}

class _BottomBar extends StatelessWidget {
  final int amount;
  final VoidCallback onPay;
  const _BottomBar({required this.amount, required this.onPay});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E5EA))),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
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
                  const SizedBox(height: 2),
                  Text(
                    _price(amount),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onPay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                ),
                child: const Text('확인 및 결제', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 가격 포맷터
String _price(int v) {
  final s = v.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ',',
  );
  return '₩$s KRW';
}

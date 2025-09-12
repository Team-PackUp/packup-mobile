import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';

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

  // 이중 내비 방지
  bool _navigated = false;

  String get _clientKey => const String.fromEnvironment(
    'TOSS_CLIENT_KEY',
    defaultValue: 'test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm', // 테스트 키
  );

  @override
  void initState() {
    super.initState();
    _paymentWidget = PaymentWidget(
      clientKey: _clientKey,
      customerKey: widget.args.customerKey,
    );

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
                ],
              ),
            ),
            _BottomBar(amount: args.amount, onPay: _onPay),
          ],
        ),
      ),
    );
  }

  bool _popped = false;

  Future<void> _onPay() async {
    try {
      final result = await _paymentWidget.requestPayment(
        paymentInfo: PaymentInfo(
          orderId: widget.args.orderId,
          orderName: widget.args.orderName,
        ),
      );

      if (!mounted || _popped) return;

      if (result.success != null) {
        _popped = true;
        // 원본 Success 객체를 그대로 넘겨도 되고,
        // 서버 confirm에 필요한 값만 골라 커스텀으로 넘겨도 됩니다.
        context.pop(result.success);
      } else if (result.fail != null) {
        _popped = true;
        context.pop(result.fail);
      } else {
        _popped = true;
        context.pop('unknown');
      }
    } catch (e) {
      if (!mounted || _popped) return;
      _popped = true;
      context.pop(e);
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

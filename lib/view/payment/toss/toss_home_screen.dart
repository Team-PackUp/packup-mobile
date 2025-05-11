import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:packup/view/payment/toss/toss_payment_screen.dart';
import 'package:packup/provider/payment/toss/toss_payment_provider.dart';
import 'package:tosspayments_widget_sdk_flutter/model/paymentData.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';

class TossHomeScreen extends StatefulWidget {
  const TossHomeScreen({super.key});

  @override
  State<TossHomeScreen> createState() => _TossHomeScreenState();
}

class _TossHomeScreenState extends State<TossHomeScreen> {
  final _form = GlobalKey<FormState>();
  late String payMethod = '카드';
  late String orderId;
  late String orderName;
  late String amount;
  late String customerName;
  late String customerEmail;

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.read<TossPaymentProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('toss payments 결제 테스트'),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: '카드',
                decoration: const InputDecoration(
                  labelText: '결제수단',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
                ),
                onChanged: (String? newValue) {
                  payMethod = newValue ?? '카드';
                },
                items: ['카드', '가상계좌', '계좌이체', '휴대폰', '상품권']
                    .map((String i) => DropdownMenuItem(
                          value: i,
                          child: Text(i),
                        ))
                    .toList(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '주문번호(orderId)'),
                initialValue:
                    'tosspaymentsFlutter_${DateTime.now().millisecondsSinceEpoch}',
                onSaved: (value) => orderId = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '주문명(orderName)'),
                initialValue: 'Toss T-shirt',
                onSaved: (value) => orderName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '결제금액(amount)'),
                initialValue: '50000',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) => amount = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '구매자명(customerName)'),
                initialValue: '김토스',
                onSaved: (value) => customerName = value!,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: '이메일(customerEmail)'),
                initialValue: 'email@tosspayments.com',
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => customerEmail = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _form.currentState!.save();

                  final paymentData = PaymentData(
                    paymentMethod: payMethod,
                    orderId: orderId,
                    orderName: orderName,
                    amount: int.parse(amount),
                    customerName: customerName,
                    customerEmail: customerEmail,
                    successUrl: Constants.success,
                    failUrl: Constants.fail,
                  );

                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TossPaymentScreen(data: paymentData),
                      fullscreenDialog: true,
                    ),
                  );

                  if (result is Success) {
                    final confirmResult = await paymentProvider.confirmPayment(
                      paymentKey: result.paymentKey,
                      orderId: result.orderId,
                      amount: result.amount.toInt(),
                    );

                    if (confirmResult?.resultFlag == true) {
                      context.push('/result', extra: result);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(confirmResult?.message ?? '결제 확인 실패'),
                        ),
                      );
                    }
                  } else if (result is Fail) {
                    context.push('/result', extra: result);
                  }
                },
                child: const Text(
                  '결제하기',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

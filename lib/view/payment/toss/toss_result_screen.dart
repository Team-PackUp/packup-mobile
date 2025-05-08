import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';

/// [TossResultScreen] class는 결제의 성공 혹은 실패 여부를 보여주는 위젯입니다.
class TossResultScreen extends StatelessWidget {
  /// 기본 생성자입니다.
  const TossResultScreen({super.key});

  /// 주어진 title과 message를 이용하여 [Row]를 생성합니다.
  Row makeRow(String title, String message) {
    return Row(children: [
      Expanded(
          flex: 3,
          child: Text(title, style: const TextStyle(color: Colors.grey))),
      Expanded(
        flex: 8,
        child: Text(message),
      )
    ]);
  }

  /// 결제 결과에 따라 적절한 내용을 반환합니다.
  Widget getResultWidget(dynamic result) {
    // Success 타입인 경우
    if (result is Success) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          makeRow('paymentKey', result.paymentKey),
          const SizedBox(height: 20),
          makeRow('orderId', result.orderId),
          const SizedBox(height: 20),
          makeRow('amount', result.amount.toString()),
          const SizedBox(height: 20),
          ...?result.additionalParams?.entries.map<Widget>((e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  makeRow(e.key, e.value),
                  const SizedBox(height: 10),
                ],
              )),
        ],
      );
    }

    // Fail 타입인 경우
    if (result is Fail) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          makeRow('errorCode', result.errorCode),
          const SizedBox(height: 20),
          makeRow('errorMessage', result.errorMessage),
          const SizedBox(height: 20),
          makeRow('orderId', result.orderId),
        ],
      );
    }

    // 그 외의 경우
    return const SizedBox(); // 빈 위젯 반환
  }

  /// 위젯을 빌드합니다.
  @override
  Widget build(BuildContext context) {
    final result = GoRouterState.of(context).extra;
    String message;

    if (result is Success) {
      message = '인증 성공! 결제승인 API를 호출해 결제를 완료했습니다.';
    } else {
      message = '결제에 실패하였습니다.';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제 결과'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),
              getResultWidget(result),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                onPressed: () {
                  context.go('/home');
                },
                label: const Text(
                  '홈으로',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

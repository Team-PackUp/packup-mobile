import 'package:flutter/material.dart';

import 'package:packup/const/color.dart';

import 'package:packup/widget/payment/toss/toss_payment/toss_payment.dart';

import 'package:packup/widget/payment/toss/toss_widget/toss_payment2.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: PRIMARY_COLOR,
        title: Text('Home', style: TextStyle(color: TEXT_COLOR_W)),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const TossPayment(title: 'Tosspayments1'),
                  ),
                );
              },
              child: const Text('깃'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const TossPayment2(),
                  ),
                );
              },
              child: const Text('예시코드'),
            ),
          ],
        ),
      ),
    );
  }
}

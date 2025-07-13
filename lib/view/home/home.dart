import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/search_bar/custom_search_bar_provider.dart';
import 'package:provider/provider.dart';

import 'package:packup/const/color.dart';

import 'package:packup/view/payment/toss/toss_home_screen.dart';
import 'package:packup/view/payment/toss/toss_intro_screen.dart';
import 'package:packup/view/payment/toss/toss_payment_screen.dart';
import 'package:packup/view/payment/toss/toss_result_screen.dart';
import 'package:packup/view/payment/toss/toss_widget_home_screen.dart';
import 'package:packup/view/payment/toss/toss_widget_payment_screen.dart';

import '../../widget/search_bar/custom_search_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchBarProvider()..setApiUrl('home/search'),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: PRIMARY_COLOR,
          title: Text('Home', style: TextStyle(color: TEXT_COLOR_W)),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const TossPaymentScreen(),
              //       ),
              //     );
              //   },
              //   child: const Text('예시코드-TossPaymentScreen'),
              // ),
              // const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TossResultScreen(),
                    ),
                  );
                },
                child: const Text('예시코드-TossResultScreen'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WidgetHome(),
                    ),
                  );
                },
                child: const Text('예시코드-WidgetHome'),
              ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const PaymentWidgetExamplePage(),
              //       ),
              //     );
              //   },
              //   child: const Text('예시코드'),
              // ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WidgetHome(),
                    ),
                  );
                },
                child: const Text('예시코드-WidgetHome'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.push('/reply_list/4/REPLY_TOUR');
                },
                child: const Text('댓글 리스트'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.push('/reply_write/4/REPLY_TOUR');
                },
                child: const Text('댓글 신규 작성'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

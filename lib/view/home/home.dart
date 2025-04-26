import 'package:flutter/material.dart';
import 'package:packup/provider/search_bar/custom_search_bar_provider.dart';
import 'package:provider/provider.dart';

import 'package:packup/const/color.dart';
import 'package:packup/widget/payment/toss/toss_payment/toss_payment.dart';
import 'package:packup/widget/payment/toss/toss_widget/toss_payment2.dart';

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
                child: CustomSearchBar(),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TossPayment(title: 'Tosspayments1'),
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
                      builder: (context) => const TossPayment2(),
                    ),
                  );
                },
                child: const Text('예시코드'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

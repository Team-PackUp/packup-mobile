import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:packup/widget/payment/toss/toss_payment/screen/intro.dart';
import 'package:packup/widget/payment/toss/toss_payment/screen/result.dart';
import 'package:packup/widget/payment/toss/toss_payment/screen/tosspayment_widget/widget_home.dart';

import 'package:packup/widget/payment/toss/toss_payment/screen/tosspayment/home.dart';


class TossPayment extends StatefulWidget {
  /// Creates a TosspaymentsSampleHome with a given title.
  const TossPayment({Key? key, required this.title}) : super(key: key);

  /// The title displayed on the home screen.
  final String title;

  /// Creates the mutable state for this widget at a given location in the tree.
  @override
  State<TossPayment> createState() => _TossPayment();
}


class _TossPayment extends State<TossPayment> {
  static const Color primaryColor = Color(0x0f0064ff);

  /// Describes the part of the user interface represented by this widget.
  ///
  /// This function returns a [GetMaterialApp] with the [primaryColor] theme.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return GetMaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      getPages: [
        GetPage(name: '/', page: () => const Intro()),
        GetPage(name: '/home', page: () => const Home()),
        GetPage(name: '/widget_home', page: () => const WidgetHome()),
        GetPage(name: '/result', page: () => const ResultPage())
      ],
    );
  }
}
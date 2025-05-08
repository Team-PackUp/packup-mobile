import 'package:packup/view/payment/toss/toss_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tosspayments_widget_sdk_flutter/utils/phase.dart';

import 'package:packup/widget/payment/toss/components.dart';
import 'package:packup/view/payment/toss/toss_widget_home_screen.dart';


class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: BlueButton(
                                onPressed: () {
                                  Get.to(() => const TossHomeScreen());
                                },
                                text: '일반결제')),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(children: [
                      Expanded(
                          child: BlueButton(
                              onPressed: () {
                                Get.to(() => const WidgetHome());
                              },
                              text: '결제위젯'))
                    ]),
                    const SizedBox(height: 30),

                    // For Dev
                    DropdownButtonFormField(
                        value: PhaseConfig.phase,
                        decoration: const InputDecoration(
                          labelText: 'build variant',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
                        ),
                        onChanged: (Phase? newPhase) async {
                          if (newPhase == null) return;
                          PhaseConfig.phase = newPhase;
                        },
                        items: Phase.values
                            .map((phase) => DropdownMenuItem(value: phase, child: Text(phase.name)))
                            .toList()),
                  ],
                ))));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/guide/guide_intro_provider.dart';
import 'package:packup/widget/guide/intro/years_round_button.dart';

class GuideIntroYearsSection extends StatelessWidget {
  const GuideIntroYearsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GuideIntroProvider>();
    final years = p.data.years;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            '예술 및 디자인\n분야에서 몇 년 동안\n일하셨나요?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              YearsRoundButton(
                icon: Icons.remove,
                onTap: () => p.decYears(min: 0, max: 50),
              ),
              // 중앙 숫자
              Text(
                (int.tryParse(years) ?? 0).toString(),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                ),
              ),
              YearsRoundButton(
                icon: Icons.add,
                onTap: () => p.incYears(min: 0, max: 50),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 직접 입력 필드(선택): 숫자만 허용
          SizedBox(
            width: 120,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '직접 입력',
                counterText: '',
              ),
              maxLength: 2,
              controller: TextEditingController(text: years)
                ..selection = TextSelection.collapsed(offset: years.length),
              onChanged: p.setYears,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

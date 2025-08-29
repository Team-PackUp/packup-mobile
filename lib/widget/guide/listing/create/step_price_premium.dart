// step_price_premium.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packup/common/util.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepPricePremium extends StatefulWidget {
  const StepPricePremium({super.key});
  @override
  State<StepPricePremium> createState() => _StepPricePremiumState();
}

class _StepPricePremiumState extends State<StepPricePremium> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    final p = context.read<ListingCreateProvider>();
    final v = p.getField<int>('pricing.premiumMin') ?? 0;
    _c = TextEditingController(text: v == 0 ? '' : v.toString());
    p.form.putIfAbsent('pricing.feeRate', () => 0.2);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  int get _value {
    final raw = _c.text.replaceAll(',', '');
    return int.tryParse(raw) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListingCreateProvider>();
    final rate = p.getField<double>('pricing.feeRate') ?? 0.2;

    final v = _value;
    final fee = (v * rate).floor();
    final host = (v - fee).clamp(0, 1 << 31);

    void _onChanged(String s) => p.setField(
      'pricing.premiumMin',
      int.tryParse(s.replaceAll(',', '')) ?? 0,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '프라이빗 예약 최저 요금',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          const Text(
            '프라이빗 예약이 가능한 최저가를 의미합니다.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Center(
            child: TextField(
              controller: _c,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w800),
              decoration: const InputDecoration(
                hintText: '₩0',
                border: InputBorder.none,
              ),
              onChanged: _onChanged,
            ),
          ),

          _PriceSummary(
            basicLabel: '기본 요금',
            basicValue: v,
            feeLabel: '서비스 수수료(${(rate * 100).round()}%)',
            feeValue: fee,
            hostIncome: host,
          ),
          const SizedBox(height: 8),
          const Text(
            '입력을 비워두면 이 단계는 건너뛰게 됩니다.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  final String basicLabel;
  final int basicValue;
  final String feeLabel;
  final int feeValue;
  final int hostIncome;
  const _PriceSummary({
    required this.basicLabel,
    required this.basicValue,
    required this.feeLabel,
    required this.feeValue,
    required this.hostIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          _row(basicLabel, formatPrice(basicValue)),
          const SizedBox(height: 8),
          _row(feeLabel, '-${formatPrice(feeValue)}'),
          const Divider(height: 24),
          _row('호스트 수입', formatPrice(hostIncome), bold: true),
        ],
      ),
    );
  }

  Widget _row(String l, String r, {bool bold = false}) {
    final style = TextStyle(
      fontSize: 16,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(l, style: style), Text(r, style: style)],
    );
  }
}

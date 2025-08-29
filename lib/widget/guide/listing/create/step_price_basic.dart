// step_price_basic.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packup/common/util.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepPriceBasic extends StatefulWidget {
  const StepPriceBasic({super.key});
  @override
  State<StepPriceBasic> createState() => _StepPriceBasicState();
}

class _StepPriceBasicState extends State<StepPriceBasic> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    final p = context.read<ListingCreateProvider>();
    final v = p.getField<int>('pricing.basic') ?? 0;
    _c = TextEditingController(text: v == 0 ? '' : v.toString());
    // 기본 수수료율 없으면 20% 저장
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
    final feeRate = p.getField<double>('pricing.feeRate') ?? 0.2;

    final basic = _value;
    final fee = (basic * feeRate).floor();
    final host = (basic - fee).clamp(0, 1 << 31);

    void _onChanged(String v) {
      final n = int.tryParse(v.replaceAll(',', '')) ?? 0;
      p.setField('pricing.basic', n);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.help_outline, size: 18),
              SizedBox(width: 6),
              Text(
                '게스트 1인당 요금',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 금액 입력(큰 폰트)
          Center(
            child: SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _c,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
                decoration: const InputDecoration(
                  hintText: '₩0',
                  border: InputBorder.none,
                ),
                onChanged: _onChanged,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 요약 박스
          _PriceSummary(
            basicLabel: '기본 요금',
            basicValue: basic,
            feeLabel: '서비스 수수료(${(feeRate * 100).round()}%)',
            feeValue: fee,
            hostIncome: host,
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

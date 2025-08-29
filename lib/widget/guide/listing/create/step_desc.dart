import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepDesc extends StatefulWidget {
  const StepDesc({super.key});

  @override
  State<StepDesc> createState() => _StepDescState();
}

class _StepDescState extends State<StepDesc> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    final p = context.read<ListingCreateProvider>();
    _c = TextEditingController(
      text: p.getField<String>('basic.description') ?? '',
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListingCreateProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '투어 소개를 입력해 주세요.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _c,
            maxLines: 8,
            minLines: 6,
            decoration: const InputDecoration(
              hintText: '예) 서울의 주요 야경 명소를 도보로 둘러보며, 역사와 숨은 이야기를 소개합니다…',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: (v) => p.setField('basic.description', v),
          ),
          const SizedBox(height: 8),
          const Text(
            '핵심 혜택, 동선, 소요시간, 준비물 등을 간단히 안내해 주세요.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepTitle extends StatefulWidget {
  const StepTitle({super.key});

  @override
  State<StepTitle> createState() => _StepTitleState();
}

class _StepTitleState extends State<StepTitle> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    final p = context.read<ListingCreateProvider>();
    _c = TextEditingController(text: p.getField<String>('basic.title') ?? '');
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
            '투어 제목을 입력해 주세요.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _c,
            maxLength: 90,
            decoration: const InputDecoration(
              hintText: '예) 서울 도보 야경 투어',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              counterText: '',
            ),
            onChanged: (v) => p.setField('basic.title', v),
          ),
          const SizedBox(height: 8),
          const Text(
            '짧고 명확하게 작성하면 좋아요. (최대 90자)',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

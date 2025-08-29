import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepExclude extends StatefulWidget {
  const StepExclude({super.key});

  @override
  State<StepExclude> createState() => _StepExcludeState();
}

class _StepExcludeState extends State<StepExclude> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    final p = context.read<ListingCreateProvider>();
    _c = TextEditingController(text: p.getField<String>('excludes.text') ?? '');
  }

  void _syncToProvider(String raw) {
    final p = context.read<ListingCreateProvider>();
    final list =
        raw
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
    p.setField('excludes.text', raw);
    p.setField('excludes.list', list);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListingCreateProvider>();
    final count = (p.getField<List>('excludes.list') ?? const []).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '포함되지 않는 항목',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _c,
            maxLines: 10,
            minLines: 6,
            decoration: const InputDecoration(
              hintText: '한 줄에 하나씩 입력해 주세요.\n예) 개인 경비\n예) 저녁 식사\n예) 교통비',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: _syncToProvider,
          ),
          const SizedBox(height: 8),
          Text('항목 수: $count', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

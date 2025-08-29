import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepProvision extends StatelessWidget {
  const StepProvision({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListingCreateProvider>();

    Widget q({required String title, required String fieldKey}) {
      final val = p.getField<bool>(fieldKey);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => p.setField(fieldKey, true),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: BorderSide(
                      color: val == true ? Colors.black : Colors.black26,
                      width: 1.5,
                    ),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor:
                        val == true ? Colors.black.withOpacity(0.05) : null,
                  ),
                  child: const Text('예'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => p.setField(fieldKey, false),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: BorderSide(
                      color: val == false ? Colors.black : Colors.black26,
                      width: 1.5,
                    ),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor:
                        val == false ? Colors.black.withOpacity(0.05) : null,
                  ),
                  child: const Text('아니요'),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          const SizedBox(height: 16),

          q(
            title: '박물관, 랜드마크, 시민광장 등 관광 명소를 방문하나요?',
            fieldKey: 'provision.visitAttractions',
          ),
          const SizedBox(height: 18),

          q(
            title: '이러한 장소의 중요성이나 역사에 대해 설명하시나요?',
            fieldKey: 'provision.explainHistory',
          ),
          const SizedBox(height: 18),

          q(title: '게스트를 운송할 예정인가요?', fieldKey: 'provision.driveGuests'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '제공 항목을 알려주세요',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            '면허, 보험, 퀄리티, 기준에 대한 확인이 필요한지 판단하기 위해 필요한 정보입니다.',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

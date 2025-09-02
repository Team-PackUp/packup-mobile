import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepLocationAddress extends StatefulWidget {
  const StepLocationAddress({super.key});
  @override
  State<StepLocationAddress> createState() => _StepLocationAddressState();
}

class _StepLocationAddressState extends State<StepLocationAddress> {
  final _formKey = GlobalKey<FormState>();
  final _country = TextEditingController(text: '대한민국');
  final _road = TextEditingController();
  final _detail = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController(text: '서울특별시');
  final _zip = TextEditingController();
  final _placeLabel = TextEditingController();

  late final ListingCreateProvider _p;

  @override
  void initState() {
    super.initState();
    _p = context.read<ListingCreateProvider>();

    _road.text = _p.getField<String>('meet.road') ?? '';
    _city.text = _p.getField<String>('meet.city') ?? '';
    _state.text = _p.getField<String>('meet.state') ?? _state.text;
    _zip.text = _p.getField<String>('meet.zip') ?? '';
    _placeLabel.text = _p.getField<String>('meet.placeLabel') ?? '';

    // ✅ 다음으로 가기 전에 필수값 검증
    _p.setNextGuard('addr', () async {
      FocusManager.instance.primaryFocus?.unfocus();
      if (!_formKey.currentState!.validate()) return false;

      _p.setFields({
        'meet.country': _country.text.trim(),
        'meet.road': _road.text.trim(),
        'meet.detail': _detail.text.trim(),
        'meet.city': _city.text.trim(),
        'meet.state': _state.text.trim(),
        'meet.zip': _zip.text.trim(),
        'meet.placeLabel': _placeLabel.text.trim(),
      });
      return true;
    });
  }

  @override
  void dispose() {
    _p.setNextGuard('addr', null);
    _country.dispose();
    _road.dispose();
    _detail.dispose();
    _city.dispose();
    _state.dispose();
    _zip.dispose();
    _placeLabel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hintStyle = TextStyle(color: Colors.black.withOpacity(0.35));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              '위치 확인',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              '게스트와 만나는 위치를 입력해주세요.\n리스팅 등록 후에는 변경할 수 없습니다.',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // 필요 시 다른 필드 복구
                    _LabeledField(
                      label: '시/도 *',
                      child: TextFormField(
                        controller: _state,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: '예) 서울특별시 / 경기도 / 부산광역시',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return '시/도를 입력해주세요.';
                          }
                          if (v.trim().length < 2) {
                            return '시/도를 정확히 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                    ),
                    _LabeledField(
                      label: '장소에 대한 설명 *',
                      child: TextFormField(
                        controller: _placeLabel,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 3, // ✅ 높이 키움
                        maxLines: 5, // ✅ 최대 높이
                        decoration: InputDecoration(
                          hintText: '예) 홍대입구역 2번 출구 앞, XX카페 입구',
                          hintStyle: hintStyle,
                        ),
                        validator: (v) {
                          final t = (v ?? '').trim();
                          if (t.isEmpty) return '장소에 대한 설명을 입력해주세요.';
                          if (t.length < 6) return '설명을 조금 더 구체적으로 적어주세요.';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

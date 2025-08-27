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

  late final ListingCreateProvider _p; // ✅ context 대신 보관

  @override
  void initState() {
    super.initState();
    _p = context.read<ListingCreateProvider>(); // ✅ 여기서만 읽기

    _road.text = _p.getField<String>('meet.road') ?? '';
    _city.text = _p.getField<String>('meet.city') ?? '';
    _state.text = _p.getField<String>('meet.state') ?? _state.text;
    _zip.text = _p.getField<String>('meet.zip') ?? '';
    _placeLabel.text = _p.getField<String>('meet.placeLabel') ?? '';

    // ✅ 컨테이너 '다음' 가드 등록 (context 의존 제거)
    _p.setNextGuard('addr', () async {
      // 키보드 닫기 (context 미사용)
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
    // ✅ context 쓰지 말고, 저장해둔 _p 사용
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
              '주소가 정확하게 입력되었는지 확인해 주세요.\n리스팅 등록 후에는 변경할 수 없습니다.',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _LabeledField(
                      label: '국가/지역',
                      child: _buildReadOnly(_country.text),
                    ),
                    _LabeledField(
                      label: '도로명 주소',
                      child: TextFormField(
                        controller: _road,
                        decoration: const InputDecoration(
                          hintText: '예) 동교동 172-82',
                        ),
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? '도로명 주소를 입력해주세요.'
                                    : null,
                      ),
                    ),
                    _LabeledField(
                      label: '아파트 층수/호수, 건물명(해당하는 경우)',
                      child: TextFormField(controller: _detail),
                    ),
                    _LabeledField(
                      label: '시/군/구',
                      child: TextFormField(
                        controller: _city,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? '시/군/구를 입력해주세요.'
                                    : null,
                      ),
                    ),
                    _LabeledField(
                      label: '주/도/군주(해당하는 경우)',
                      child: TextFormField(controller: _state),
                    ),
                    _LabeledField(
                      label: '우편번호(해당하는 경우)',
                      child: TextFormField(
                        controller: _zip,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    _LabeledField(
                      label: '장소 이름(선택 사항)',
                      child: TextFormField(controller: _placeLabel),
                    ),
                  ],
                ),
              ),
            ),
            // 하단 버튼 없음 — 컨테이너에서만 렌더링
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnly(String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.arrow_drop_down),
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

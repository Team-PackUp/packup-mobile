import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepLocationSearch extends StatefulWidget {
  const StepLocationSearch({super.key});

  @override
  State<StepLocationSearch> createState() => _StepLocationSearchState();
}

class _StepLocationSearchState extends State<StepLocationSearch> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    final selected = context.read<ListingCreateProvider>().getField<String>(
      'meet.placeName',
    );
    if (selected != null && selected.isNotEmpty) {
      _controller.text = selected;
      _query = selected;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 추후 구글맵 api 붙이기
  List<_Suggestion> _fakeSearch(String q) {
    if (q.trim().isEmpty) return [];
    final base = q.trim();
    return [
      _Suggestion(title: '$base 앞', subtitle: '서울특별시'),
      _Suggestion(title: '$base 5번 출구', subtitle: '대한민국 서울특별시 마포구 동교동'),
      _Suggestion(title: '$base 2번출구앞자전거대여소', subtitle: '대한민국 서울특별시 마포구 양화로'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListingCreateProvider>();
    final selectedName = p.getField<String>('meet.placeName');
    final results = _fakeSearch(_query);
    final canNext = (selectedName != null && selectedName.isNotEmpty);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '게스트와 만나는 장소가 어디인가요?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '예) 홍대입구역',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:
                            (_controller.text.isEmpty)
                                ? null
                                : IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _controller.clear();
                                    setState(() => _query = '');
                                    p.setField('meet.placeName', null);
                                    p.setField('meet.address', null);
                                  },
                                ),
                        filled: true,
                        fillColor: const Color(0xFFF6F6F8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                      onSubmitted: (v) => setState(() => _query = v),
                      textInputAction: TextInputAction.search,
                    ),
                    const SizedBox(height: 12),

                    if (selectedName != null && selectedName.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: [
                          InputChip(
                            label: Text(selectedName),
                            onDeleted: () {
                              p.setField('meet.placeName', null);
                              p.setField('meet.address', null);
                              setState(() {});
                            },
                          ),
                        ],
                      ),

                    if (results.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text('추천', style: TextStyle(color: Colors.black54)),
                    ],
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child:
                results.isEmpty && _query.isNotEmpty
                    ? const Center(child: Text('검색 결과가 없습니다.'))
                    : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final s = results[i];
                        final isSelected = selectedName == s.title;
                        return ListTile(
                          leading: const Icon(Icons.place_outlined),
                          title: Text(
                            s.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(s.subtitle),
                          trailing:
                              isSelected
                                  ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.black,
                                  )
                                  : null,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            _controller.text = s.title;
                            setState(() => _query = s.title);
                            p.setField('meet.placeName', s.title);
                            p.setField('meet.address', s.subtitle);
                          },
                        );
                      },
                    ),
          ),

          // Padding(
          //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          //   child: SizedBox(
          //     width: double.infinity,
          //     child: ElevatedButton(
          //       onPressed:
          //           canNext
          //               ? () => context.read<ListingCreateProvider>().next()
          //               : null,
          //       style: ElevatedButton.styleFrom(
          //         minimumSize: const Size.fromHeight(56),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(16),
          //         ),
          //       ),
          //       child: const Text('다음'),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _Suggestion {
  final String title;
  final String subtitle;
  const _Suggestion({required this.title, required this.subtitle});
}

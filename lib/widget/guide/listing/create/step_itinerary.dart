import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepItinerary extends StatefulWidget {
  const StepItinerary({super.key});
  @override
  State<StepItinerary> createState() => _StepItineraryState();
}

class _StepItineraryState extends State<StepItinerary> {
  late ListingCreateProvider _p;
  bool _guardBound = false;
  bool _initialized = false;

  final _picker = ImagePicker();

  final List<_Activity> _items = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _p = context.read<ListingCreateProvider>();

    if (!_initialized) {
      final raw = _p.getField<List>('itinerary.items') ?? const [];
      final saved =
          raw
              .cast<Map>()
              .map((m) => _Activity.fromMap(Map<String, dynamic>.from(m)))
              .toList();

      _items
        ..clear()
        ..addAll(saved);

      _p.setNextGuard('itinerary', () async {
        if (_items.isEmpty) {
          _snack('활동을 1개 이상 추가해 주세요.');
          return false;
        }
        _p.setFields({
          'itinerary.items': _items.map((e) => e.toMap()).toList(),
          'itinerary.count': _items.length,
        });
        return true;
      });

      _guardBound = true;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    if (_guardBound) _p.setNextGuard('itinerary', null);
    super.dispose();
  }

  void _syncToProvider() {
    final serialized = <Map<String, dynamic>>[];
    for (var i = 0; i < _items.length; i++) {
      serialized.add(_items[i].toMap(order: i + 1)); // ← order 부여
    }
    _p.setFields({
      'itinerary.items': serialized,
      'itinerary.count': serialized.length,
    });
  }

  void _snack(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _openEditor({_Activity? initial, int? index}) async {
    final res = await showModalBottomSheet<_Activity>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _ActivityEditor(initial: initial),
    );
    if (res == null) return;

    setState(() {
      if (index == null) {
        if (_items.length >= 5) {
          _snack('활동은 최대 5개까지 추가할 수 있어요.');
          return;
        }
        _items.add(res);
      } else {
        _items[index] = res;
      }
    });
    _syncToProvider();
  }

  void _deleteAt(int index) {
    setState(() => _items.removeAt(index));
    _syncToProvider();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _items.isEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: 16),

            Expanded(
              child:
                  isEmpty
                      ? ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _AddCardLarge(onTap: () => _openEditor()),
                          const SizedBox(height: 8),
                        ],
                      )
                      : ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ...List.generate(
                            _items.length,
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _ActivityCardLarge(
                                data: _items[i],
                                onTap:
                                    () => _openEditor(
                                      initial: _items[i],
                                      index: i,
                                    ),
                                onDelete: () => _deleteAt(i),
                              ),
                            ),
                          ),
                          _AddCardLarge(onTap: () => _openEditor()),
                          const SizedBox(height: 8),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        const Text(
          '일정표 만들기',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          '게스트가 체험을 잘 파악할 수 있도록 활동을 최대 5개까지 추가하세요.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
      ],
    );
  }
}

class _AddCardLarge extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCardLarge({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDeco(),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.add, size: 28),
              ),
              const SizedBox(width: 12),
              const Text(
                '활동 추가하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCardLarge extends StatelessWidget {
  final _Activity data;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const _ActivityCardLarge({
    required this.data,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDeco(),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child:
                    data.photoPath == null
                        ? Container(
                          width: 96,
                          height: 96,
                          color: const Color(0xFFF1F2F5),
                        )
                        : Image.file(
                          File(data.photoPath!),
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _minToText(data.minutes),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if ((data.note?.isNotEmpty ?? false)) ...[
                      const SizedBox(height: 6),
                      Text(
                        data.note!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityEditor extends StatefulWidget {
  final _Activity? initial;
  const _ActivityEditor({this.initial});

  @override
  State<_ActivityEditor> createState() => _ActivityEditorState();
}

class _ActivityEditorState extends State<_ActivityEditor> {
  final _title = TextEditingController();
  final _note = TextEditingController();
  int _minutes = 60;
  XFile? _photo;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    if (i != null) {
      _title.text = i.title;
      _note.text = i.note ?? '';
      _minutes = i.minutes;
      if (i.photoPath != null) _photo = XFile(i.photoPath!);
    }
  }

  Future<void> _pick() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1800,
    );
    if (x != null) setState(() => _photo = x);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '활동 추가/수정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: '활동명',
                  hintText: '예) 삼겹살 투어',
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  const Text('소요 시간'),
                  const SizedBox(width: 12),
                  DropdownButton<int>(
                    value: _minutes,
                    items:
                        const [30, 45, 60, 75, 90, 120, 150, 180]
                            .map(
                              (m) => DropdownMenuItem(
                                value: m,
                                child: Text(_minToText(m)),
                              ),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => _minutes = v ?? 60),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _pick,
                    icon: const Icon(Icons.photo),
                    label: const Text('사진'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _note,
                maxLines: 3,
                decoration: const InputDecoration(labelText: '상세 설명 (선택)'),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_title.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('활동명을 입력하세요.')),
                      );
                      return;
                    }
                    Navigator.pop(
                      context,
                      _Activity(
                        title: _title.text.trim(),
                        minutes: _minutes,
                        note:
                            _note.text.trim().isEmpty
                                ? null
                                : _note.text.trim(),
                        photoPath: _photo?.path,
                      ),
                    );
                  },
                  child: const Text('완료'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- model / utils ----

class _Activity {
  final String id;
  final String title;
  final int minutes;
  final String? note;
  final String? photoPath;

  _Activity({
    String? id,
    required this.title,
    required this.minutes,
    this.note,
    this.photoPath,
  }) : id = id ?? UniqueKey().toString();

  Map<String, dynamic> toMap({int? order}) {
    final map = <String, dynamic>{
      'order': order,
      'title': title,
      'intro': note,
      'durationMin': minutes,
      'thumbs': photoPath == null ? <String>[] : <String>[photoPath!],
      'id': id,
      'minutes': minutes,
      'note': note,
      'photoPath': photoPath,
    };
    map.removeWhere((k, v) => v == null);
    return map;
  }

  factory _Activity.fromMap(Map<String, dynamic> m) {
    final t = (m['title'] ?? m['activityTitle'])?.toString() ?? '';
    final minutes =
        (m['durationMin'] ?? m['activityDurationMinute'] ?? m['minutes'])
            as int? ??
        60;
    final note =
        (m['intro'] ?? m['activityIntroduce'] ?? m['note'])?.toString();
    String? photo;

    final thumbs = (m['thumbs'] ?? m['thumbnailUrls']) as List?;
    if (thumbs != null && thumbs.isNotEmpty) {
      photo = thumbs.first?.toString();
    } else {
      photo = m['photoPath']?.toString();
    }

    return _Activity(
      id: m['id']?.toString(),
      title: t,
      minutes: minutes,
      note: note,
      photoPath: photo,
    );
  }
}

BoxDecoration _boxDeco() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18),
  boxShadow: const [
    BoxShadow(color: Colors.black12, blurRadius: 22, offset: Offset(0, 10)),
  ],
);

String _minToText(int m) {
  final h = m ~/ 60;
  final mm = m % 60;
  if (h == 0) return '$m분';
  if (mm == 0) return '${h}시간';
  return '${h}시간 ${mm}분';
}

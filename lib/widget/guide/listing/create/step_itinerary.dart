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
  final _introCtrl = TextEditingController();
  XFile? _thumb;

  bool _reorderMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _p = context.read<ListingCreateProvider>();

    if (!_initialized) {
      final saved = _p.getField<List>('itinerary.items')?.cast<Map>() ?? [];
      _items.addAll(
        saved.map((m) => _Activity.fromMap(m.cast<String, dynamic>())),
      );
      _introCtrl.text = _p.getField<String>('itinerary.intro') ?? '';
      final thumbPath = _p.getField<String>('itinerary.thumbPath');
      if (thumbPath != null && thumbPath.isNotEmpty) _thumb = XFile(thumbPath);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _syncToProvider();
      });

      _p.setNextGuard('itinerary', () async {
        if (_items.isEmpty) {
          _showSnack('활동을 1개 이상 추가해 주세요.');
          return false;
        }
        if (_introCtrl.text.trim().isEmpty) {
          _showSnack('체험 소개를 입력해 주세요.');
          return false;
        }
        if (_thumb == null) {
          _showSnack('썸네일 사진을 선택해 주세요.');
          return false;
        }
        _p.setFields({
          'itinerary.items': _items.map((e) => e.toMap()).toList(),
          'itinerary.intro': _introCtrl.text.trim(),
          'itinerary.thumbPath': _thumb!.path,
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
    _introCtrl.dispose();
    super.dispose();
  }

  void _syncToProvider() {
    _p.setFields({
      'itinerary.items': _items.map((e) => e.toMap()).toList(),
      'itinerary.intro': _introCtrl.text.trim(),
      'itinerary.thumbPath': _thumb?.path ?? '',
      'itinerary.count': _items.length,
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _pickThumb() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (x == null) return;
    setState(() => _thumb = x);
    _syncToProvider();
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
          _showSnack('활동은 최대 5개까지 추가할 수 있어요.');
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              title: '일정표',
              subtitle: '활동을 5개까지 추가할 수 있습니다.',
              trailing: TextButton(
                onPressed: () => setState(() => _reorderMode = !_reorderMode),
                child: Text(_reorderMode ? '완료' : '순서 변경'),
              ),
            ),
            const SizedBox(height: 12),

            _ThumbAndIntro(
              thumb: _thumb,
              onPickThumb: _pickThumb,
              introController: _introCtrl,
            ),
            const SizedBox(height: 12),

            Expanded(
              child:
                  _reorderMode
                      ? ReorderableListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _items.length + 1,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) newIndex -= 1;
                            if (oldIndex == _items.length) return;
                            if (newIndex > _items.length)
                              newIndex = _items.length;
                            final item = _items.removeAt(oldIndex);
                            _items.insert(newIndex, item);
                          });
                          _syncToProvider();
                        },
                        itemBuilder: (context, i) {
                          if (i == _items.length) {
                            return _AddCard(
                              key: const ValueKey('add'),
                              onTap: () => _openEditor(),
                            );
                          }
                          final e = _items[i];
                          return _ActivityCard(
                            key: ValueKey(e.id),
                            data: e,
                            onTap: () => _openEditor(initial: e, index: i),
                            onDelete: () => _deleteAt(i),
                            reorderable: true,
                          );
                        },
                      )
                      : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _items.length + 1,
                        itemBuilder: (context, i) {
                          if (i == _items.length) {
                            return _AddCard(onTap: () => _openEditor());
                          }
                          final e = _items[i];
                          return _ActivityCard(
                            data: e,
                            onTap: () => _openEditor(initial: e, index: i),
                            onDelete: () => _deleteAt(i),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  const _Header({required this.title, required this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _ThumbAndIntro extends StatelessWidget {
  final XFile? thumb;
  final VoidCallback onPickThumb;
  final TextEditingController introController;
  const _ThumbAndIntro({
    required this.thumb,
    required this.onPickThumb,
    required this.introController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDeco(),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPickThumb,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 72,
                height: 72,
                color: const Color(0xFFF1F2F5),
                child:
                    thumb == null
                        ? const Icon(Icons.add_a_photo_outlined)
                        : Image.file(File(thumb!.path), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 소개 입력
          Expanded(
            child: TextField(
              controller: introController,
              minLines: 2,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '체험에 대한 소개를 입력하세요',
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _boxDeco(),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.add),
        ),
        title: const Text(
          '활동 추가하기',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final _Activity data;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool reorderable;
  const _ActivityCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.onDelete,
    this.reorderable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _boxDeco(),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              data.photoPath == null
                  ? Container(
                    width: 48,
                    height: 48,
                    color: const Color(0xFFF1F2F5),
                  )
                  : Image.file(
                    File(data.photoPath!),
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
        ),
        title: Text(
          '${data.title} · ${_minToText(data.minutes)}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: (data.note?.isNotEmpty ?? false) ? Text(data.note!) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reorderable) const Icon(Icons.drag_handle),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onTap,
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
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              TextField(
                controller: _note,
                maxLines: 3,
                decoration: const InputDecoration(labelText: '상세 설명 (선택)'),
              ),
              const SizedBox(height: 12),
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

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'minutes': minutes,
    'note': note,
    'photoPath': photoPath,
  };

  factory _Activity.fromMap(Map<String, dynamic> m) => _Activity(
    id: m['id'] as String?,
    title: m['title'] as String,
    minutes: m['minutes'] as int,
    note: m['note'] as String?,
    photoPath: m['photoPath'] as String?,
  );
}

BoxDecoration _boxDeco() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: const [
    BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10)),
  ],
);

String _minToText(int m) {
  final h = m ~/ 60;
  final mm = m % 60;
  if (h == 0) return '$m분';
  if (mm == 0) return '${h}시간';
  return '${h}시간 ${mm}분';
}

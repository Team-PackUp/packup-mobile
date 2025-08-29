import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepPhotos extends StatefulWidget {
  const StepPhotos({super.key});
  @override
  State<StepPhotos> createState() => _StepPhotosState();
}

class _StepPhotosState extends State<StepPhotos> {
  final _picker = ImagePicker();

  late ListingCreateProvider _p; // context 캐시
  bool _guardBound = false;
  bool _initialized = false;

  final List<XFile> _files = [];
  int _coverIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _p = context.read<ListingCreateProvider>();

    if (!_initialized) {
      final savedPaths =
          _p.getField<List>('photos.localPaths')?.cast<String>() ?? [];
      final savedCover = _p.getField<int>('photos.coverIndex') ?? 0;
      if (_files.isEmpty && savedPaths.isNotEmpty) {
        _files.addAll(savedPaths.map((e) => XFile(e)));
        _coverIndex =
            (savedCover >= 0 && savedCover < _files.length) ? savedCover : 0;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _syncToProvider();
      });

      _p.setNextGuard('photos', () async {
        if (_files.length < 5) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('사진을 5장 이상 첨부해 주세요.')));
          return false;
        }
        return true;
      });
      _guardBound = true;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    if (_guardBound) _p.setNextGuard('photos', null);
    super.dispose();
  }

  void _syncToProvider() {
    _p.setFields({
      'photos.localPaths': _files.map((e) => e.path).toList(),
      'photos.coverIndex': _coverIndex,
      'photos.count': _files.length, // 하단바 활성화 판정용
    });
  }

  Future<void> _pickMore() async {
    final picked = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (picked.isEmpty) return;
    setState(() {
      _files.addAll(picked);
    });
    _syncToProvider();
  }

  void _removeAt(int index) {
    setState(() {
      _files.removeAt(index);
      if (_files.isEmpty) {
        _coverIndex = 0;
      } else if (_coverIndex >= _files.length) {
        _coverIndex = 0;
      }
    });
    _syncToProvider();
  }

  void _setCover(int index) {
    setState(() => _coverIndex = index);
    _syncToProvider();
  }

  // ---- UI -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.0,
                ),
                itemCount: _files.length + 1, // +1 = 추가 타일
                itemBuilder: (context, index) {
                  if (index == _files.length) {
                    return _AddTile(onTap: _pickMore);
                  }
                  final f = _files[index];
                  final isCover = index == _coverIndex;
                  return _PhotoTile(
                    file: f,
                    isCover: isCover,
                    onTap: () => _setCover(index),
                    onRemove: () => _removeAt(index),
                  );
                },
              ),
            ),

            // Text(
            //   '사진을 5장 이상 업로드하세요.',
            //   style: TextStyle(color: Colors.black.withOpacity(0.5)),
            // ),
            const SizedBox(height: 4),
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
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(height: 6),
          Text(
            '체험의 특징이 잘 드러나는 사진을\n추가하세요',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            '사진을 5장 이상 업로드하세요.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  final VoidCallback onTap;
  const _AddTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF1F2F5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: const Center(child: Icon(Icons.add, size: 36)),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final XFile file;
  final bool isCover;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  const _PhotoTile({
    required this.file,
    required this.isCover,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(file.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        if (isCover)
          Positioned(
            left: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '커버 사진',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        Positioned(
          right: 6,
          top: 6,
          child: Material(
            color: Colors.white.withOpacity(0.85),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onRemove,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.delete_outline, size: 18),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(onTap: onTap),
          ),
        ),
      ],
    );
  }
}

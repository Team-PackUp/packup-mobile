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

  late ListingCreateProvider _p;
  bool _guardBound = false;
  bool _initialized = false;

  // 로컬로 새로 선택한 파일들
  final List<XFile> _localFiles = [];

  // 원격(미리보기용 URL)과 그에 대응하는 키/URL(서버 저장용) 쌍을 같은 인덱스로 관리
  final List<String> _remotePreviewUrls = [];
  final List<String> _remoteKeys = [];

  int _coverIndex = 0;

  static const int _maxCount = 5;

  int get _remoteCount => _remotePreviewUrls.length;
  int get _totalCount => _remotePreviewUrls.length + _localFiles.length;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _p = context.read<ListingCreateProvider>();

    if (!_initialized) {
      // 초기 상태 복구
      final savedLocal =
          _p.getField<List>('photos.localPaths')?.cast<String>() ?? const [];
      final savedPreview =
          _p
              .getField<List>('photos.previewUrls')
              ?.map((e) => e.toString())
              .toList() ??
          const <String>[];
      final savedKeys =
          _p
              .getField<List>('photos.files')
              ?.map((e) => e.toString())
              .toList() ??
          const <String>[];
      final savedCover = _p.getField<int>('photos.coverIndex') ?? 0;

      if (_localFiles.isEmpty && savedLocal.isNotEmpty) {
        _localFiles.addAll(savedLocal.map((e) => XFile(e)));
      }
      if (_remotePreviewUrls.isEmpty && savedPreview.isNotEmpty) {
        _remotePreviewUrls.addAll(savedPreview);
      }
      if (_remoteKeys.isEmpty && savedKeys.isNotEmpty) {
        _remoteKeys.addAll(savedKeys);
      }

      _coverIndex =
          (savedCover >= 0 && savedCover < _totalCount) ? savedCover : 0;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _syncToProvider();
      });

      // “정확히 5장” 가드 + 업로드 보장
      _p.setNextGuard('photos', () async {
        if (_totalCount != _maxCount) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('사진을 5장 첨부해 주세요.')));
          return false;
        }

        final ok = await _p.ensurePhotosUploaded();
        if (!ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('사진 업로드 실패: ${_p.photoUploadError ?? '알 수 없는 오류'}'),
            ),
          );
        }
        return ok;
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
      'photos.localPaths': _localFiles.map((e) => e.path).toList(), // 미업로드 로컬
      'photos.previewUrls': _remotePreviewUrls, // 표시용 URL
      'photos.files': _remoteKeys, // 서버 저장용(키/URL)
      'photos.coverIndex': _coverIndex,
      'photos.count': _totalCount,
    });
  }

  Future<void> _pickMore() async {
    final remain = _maxCount - _totalCount;
    if (remain <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('최대 5장까지 업로드할 수 있어요.')));
      return;
    }

    final picked = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (picked.isEmpty) return;

    final toAdd = picked.length > remain ? picked.sublist(0, remain) : picked;
    setState(() => _localFiles.addAll(toAdd));
    _syncToProvider();
  }

  void _removeAt(int gridIndex) {
    if (gridIndex < _remoteCount) {
      // 원격 프리뷰/키 동시 제거(인덱스 정합 유지)
      _remotePreviewUrls.removeAt(gridIndex);
      if (gridIndex < _remoteKeys.length) {
        _remoteKeys.removeAt(gridIndex);
      }
    } else {
      // 로컬 제거
      final localIndex = gridIndex - _remoteCount;
      _localFiles.removeAt(localIndex);
    }

    setState(() {
      if (_totalCount == 0) {
        _coverIndex = 0;
      } else if (_coverIndex >= _totalCount) {
        _coverIndex = 0;
      }
    });
    _syncToProvider();
  }

  void _setCover(int gridIndex) {
    setState(() => _coverIndex = gridIndex);
    _syncToProvider();
  }

  @override
  Widget build(BuildContext context) {
    // 진행률 반영
    final provider = context.watch<ListingCreateProvider>();
    final progressList = provider.photoUploadProgress;

    final total = _totalCount;
    final showAdd = total < _maxCount;
    final itemCount = showAdd ? total + 1 : total;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: 12),
            _CounterBadge(current: total, max: _maxCount),
            const SizedBox(height: 12),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.0,
                ),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (showAdd && index == itemCount - 1) {
                    return _AddTile(onTap: _pickMore);
                  }

                  final isCover = index == _coverIndex;

                  if (index < _remoteCount) {
                    final url = _remotePreviewUrls[index];
                    return _RemotePhotoTile(
                      url: url,
                      isCover: isCover,
                      onTap: () => _setCover(index),
                      onRemove: () => _removeAt(index),
                    );
                  }

                  final localIndex = index - _remoteCount;
                  final file = _localFiles[localIndex];
                  final progress =
                      (localIndex < progressList.length)
                          ? progressList[localIndex]
                          : null;

                  return _LocalPhotoTile(
                    file: file,
                    isCover: isCover,
                    progress: progress,
                    onTap: () => _setCover(index),
                    onRemove: () => _removeAt(index),
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
            '사진을 정확히 5장 업로드하세요.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _CounterBadge extends StatelessWidget {
  final int current;
  final int max;
  const _CounterBadge({required this.current, required this.max});

  @override
  Widget build(BuildContext context) {
    final done = current == max;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: done ? Colors.green.withOpacity(0.1) : Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$current / $max',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: done ? Colors.green.shade700 : Colors.black54,
          ),
        ),
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

class _RemotePhotoTile extends StatelessWidget {
  final String url;
  final bool isCover;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  const _RemotePhotoTile({
    required this.url,
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
          child: Image.network(
            url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        if (isCover) _coverBadge(),
        _deleteBtn(onRemove),
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

class _LocalPhotoTile extends StatelessWidget {
  final XFile file;
  final bool isCover;
  final double? progress;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  const _LocalPhotoTile({
    required this.file,
    required this.isCover,
    required this.progress,
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
        if (isCover) _coverBadge(),
        if (progress != null && progress! > 0.0 && progress! < 1.0)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LinearProgressIndicator(value: progress),
          ),
        _deleteBtn(onRemove),
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

// 공통 UI
Widget _coverBadge() {
  return Positioned(
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
  );
}

Widget _deleteBtn(VoidCallback onRemove) {
  return Positioned(
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
  );
}

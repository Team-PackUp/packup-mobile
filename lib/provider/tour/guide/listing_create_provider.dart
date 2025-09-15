import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_create_request.dart';
import 'package:packup/service/common/s3_upload_service.dart';
import 'package:packup/service/tour/tour_service.dart';

typedef StepBuilder = Widget Function(BuildContext context);
typedef NextGuard = Future<bool> Function();

class ListingStepConfig {
  final String id;
  final String title;
  final StepBuilder builder;
  const ListingStepConfig({
    required this.id,
    required this.title,
    required this.builder,
  });
}

class ListingCreateProvider extends ChangeNotifier {
  String? _gs(Map<String, dynamic> m, String key) => (m[key])?.toString();

  final S3UploadService _s3 = S3UploadService();

  List<double> photoUploadProgress = const [];
  String? photoUploadError;

  int? _gi(Map<String, dynamic> m, String key) {
    final v = m[key];
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  double? _gd(Map<String, dynamic> m, String key) {
    final v = m[key];
    if (v == null) return null;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  List<T> _gl<T>(Map<String, dynamic> m, String key) {
    final v = m[key];
    if (v is List) {
      return v.whereType<T>().toList();
    }
    return <T>[];
  }

  List<String> _glAsString(Map<String, dynamic> m, String key) {
    final v = m[key];
    if (v is List) {
      return v.map((e) => e.toString()).toList();
    }
    return const <String>[];
  }

  // ----------------- 기본 설정 -----------------
  final List<ListingStepConfig> steps;
  final VoidCallback? onStart;
  final TourService _service;

  ListingCreateProvider({
    required this.steps,
    this.onStart,
    TourService? service,
  }) : _service = service ?? TourService(),
       assert(steps.isNotEmpty);

  // ----------------- 폼 상태 -----------------
  final Map<String, dynamic> form = {};

  void setField(String key, dynamic value) {
    form[key] = value;
    notifyListeners();
  }

  void setFields(Map<String, dynamic> kv) {
    form.addAll(kv);
    notifyListeners();
  }

  T? getField<T>(String key) => form[key] as T?;

  void removeField(String key) {
    form.remove(key);
    notifyListeners();
  }

  // ----------------- 네비게이션(스텝) -----------------
  int _index = 0;
  int get index => _index;
  int get total => steps.length;
  ListingStepConfig get current => steps[_index];
  String get currentId => current.id;
  bool get isFirst => _index == 0;
  bool get isLast => _index == steps.length - 1;

  void start() => onStart?.call();

  void next() {
    if (!isLast) {
      _index++;
      notifyListeners();
    }
  }

  void prev() {
    if (!isFirst) {
      _index--;
      notifyListeners();
    }
  }

  void jumpTo(String stepId) {
    final i = steps.indexWhere((e) => e.id == stepId);
    if (i >= 0 && i != _index) {
      _index = i;
      notifyListeners();
    }
  }

  // ---- Guards ----
  final Map<String, NextGuard> _nextGuards = {};
  void setNextGuard(String stepId, NextGuard? guard) {
    if (guard == null) {
      _nextGuards.remove(stepId);
    } else {
      _nextGuards[stepId] = guard;
    }
  }

  Future<void> nextWithGuard() async {
    final guard = _nextGuards[currentId];
    if (guard != null) {
      final ok = await guard();
      if (!ok) return;
    }
    next();
  }

  // ----------------- 생성/제출 상태 -----------------
  bool isSubmitting = false;
  String? submitError;
  TourCreateRequest? lastRequest;

  // ----------------- 수정 모드 -----------------
  bool _editing = false;
  String? _editingId; // 리스팅/투어 ID
  bool get isEditing => _editing;
  String? get editingId => _editingId;

  bool loadingDetail = false;
  Object? detailError;

  /// 단건 상세 로딩 → 폼 주입
  Future<void> loadForEdit(String id) async {
    _editing = true;
    _editingId = id;
    loadingDetail = true;
    detailError = null;
    notifyListeners();

    try {
      final Map<String, dynamic> detail = await _service.fetchListingDetail(id);

      final title = _gs(detail, 'tourTitle') ?? '';
      final introduce = _gs(detail, 'tourIntroduce') ?? '';
      final notes = _gs(detail, 'tourNotes'); // meet.placeLabel
      final meetAddr = _gs(detail, 'meetUpAddress'); // meet.state
      final meetLat = _gd(detail, 'meetUpLat');
      final meetLng = _gd(detail, 'meetUpLng');
      final locationCode = _gi(detail, 'tourLocationCode');

      final photos = _glAsString(detail, 'photos'); // 키 or URL
      final activities = (detail['activities'] as List?) ?? const [];

      final price = _gi(detail, 'tourPrice') ?? 0;
      final privateFlag = _gs(detail, 'privateFlag'); // 'Y' / 'N'
      final privatePrice = _gi(detail, 'privatePrice');
      final keywords = _glAsString(detail, 'tourKeywords');

      final minHead = _gi(detail, 'minHeadCount');
      final maxHead = _gi(detail, 'maxHeadCount');
      final transportYN = _gs(detail, 'transportServiceFlag');
      final memo = _gs(detail, 'memo');

      setFields({
        'basic.title': title.trim(),
        'basic.description': introduce.trim(),

        'meet.placeLabel': notes ?? '',
        'meet.state': meetAddr ?? '',
        'meet.road': '',
        'meet.detail': '',
        'meet.lat': meetLat,
        'meet.lng': meetLng,
        'meet.locationCode': locationCode,

        'photos.files': photos, // 서버 보관값(키/URL)

        'itinerary.items': _mapActivitiesFromMap(activities),
        'itinerary.count': activities.length,

        'pricing.basic': price,
        'pricing.premiumMin': (privateFlag == 'Y') ? (privatePrice ?? 0) : 0,

        'keywords.selected': keywords,

        'people.min': minHead,
        'people.max': maxHead,

        'provision.driveGuests': _ynToBool(transportYN),
        'provision.visitAttractions': _inferVisit(memo),
        'provision.explainHistory': _inferExplain(memo),
      });

      // 프리뷰 URL 확보
      final keys =
          <String>[
            ...(getField<List>('photos.urls') ?? const []).map(
              (e) => e.toString(),
            ),
            ...photos.map((e) => e.toString()),
          ].where((e) => e.isNotEmpty).toList();

      if (keys.isNotEmpty) {
        final preview = await _s3.viewUrlsForKeys(keys);
        setFields({'photos.previewUrls': preview, 'photos.count': keys.length});
      }
    } catch (e) {
      detailError = e;
    } finally {
      loadingDetail = false;
      final i = steps.indexWhere((e) => e.id == 'review');
      if (i >= 0) _index = i;
      notifyListeners();
    }
  }

  bool? _inferVisit(String? memo) {
    if (memo == null) return null;
    if (memo.contains('관광명소 방문:예')) return true;
    if (memo.contains('관광명소 방문:아니요')) return false;
    return null;
  }

  bool? _inferExplain(String? memo) {
    if (memo == null) return null;
    if (memo.contains('역사 설명:예')) return true;
    if (memo.contains('역사 설명:아니요')) return false;
    return null;
  }

  static bool? _ynToBool(String? yn) {
    if (yn == null) return null;
    final s = yn.toUpperCase();
    if (s == 'Y') return true;
    if (s == 'N') return false;
    return null;
  }

  static List<Map<String, dynamic>> _mapActivitiesFromMap(List raw) {
    return raw.asMap().entries.map((entry) {
      final i = entry.key;
      final v = entry.value;
      final m =
          (v is Map)
              ? Map<String, dynamic>.from(v as Map)
              : <String, dynamic>{};

      final order =
          (m['activityOrder'] is int)
              ? m['activityOrder'] as int
              : (m['order'] is int ? m['order'] as int : i + 1);

      final aTitle = (m['activityTitle'] ?? m['title'])?.toString();
      final aIntro =
          (m['activityIntroduce'] ?? m['intro'] ?? m['note'])?.toString();
      final dur =
          (m['activityDurationMinute'] ?? m['durationMin'] ?? m['minutes']);

      List<String> thumbs = [];
      if (m['thumbnails'] is List) {
        thumbs =
            (m['thumbnails'] as List)
                .map((e) {
                  if (e is Map && e['thumbnailImageUrl'] != null) {
                    return e['thumbnailImageUrl'].toString();
                  }
                  return e.toString();
                })
                .whereType<String>()
                .toList();
      } else if (m['thumbnailUrls'] is List) {
        thumbs = (m['thumbnailUrls'] as List).map((e) => e.toString()).toList();
      } else if (m['photoPath'] != null) {
        thumbs = [m['photoPath'].toString()];
      }

      return {
        'order': order,
        'title': aTitle,
        'intro': aIntro,
        'durationMin':
            (dur is int)
                ? dur
                : (dur is num
                    ? dur.toInt()
                    : int.tryParse(dur?.toString() ?? '')),
        'thumbs': thumbs,
      };
    }).toList();
  }

  /// 로컬 이미지 업로드 + 표시용 URL 확보
  Future<bool> ensurePhotosUploaded() async {
    photoUploadError = null;

    final localPaths =
        (getField<List>('photos.localPaths') ?? const [])
            .map((e) => e.toString())
            .toList();

    // 기존(원격) 값: 키 or URL
    final existing = <String>[
      ...(getField<List>('photos.urls') ?? const []).map((e) => e.toString()),
      ...(getField<List>('photos.files') ?? const []).map((e) => e.toString()),
    ];

    if (localPaths.isEmpty) {
      if (existing.isNotEmpty) {
        final preview = await _s3.viewUrlsForKeys(existing);
        setFields({
          'photos.previewUrls': preview,
          'photos.count': existing.length,
        });
      }
      return true;
    }

    photoUploadProgress = List<double>.filled(localPaths.length, 0.0);
    notifyListeners();

    try {
      final coverIndexCombined = getField<int>('photos.coverIndex') ?? 0;

      // cover가 로컬 영역에 있으면 그것부터 업로드
      final existingLen = existing.length;
      final localCoverIndex =
          (coverIndexCombined >= existingLen)
              ? (coverIndexCombined - existingLen)
              : null;

      final order = <int>[
        if (localCoverIndex != null &&
            localCoverIndex >= 0 &&
            localCoverIndex < localPaths.length)
          localCoverIndex,
        ...List.generate(
          localPaths.length,
          (i) => i,
        ).where((i) => i != localCoverIndex),
      ];

      final uploadedKeys = <String>[];
      for (final idx in order) {
        final path = localPaths[idx];
        final xf = XFile(path);
        final key = await _s3.uploadXFileAndReturnKey(
          xf,
          prefix: "tour/gallery/",
          onProgress: (p) {
            photoUploadProgress[idx] = p;
            notifyListeners();
          },
        );
        uploadedKeys.add(key);
        photoUploadProgress[idx] = 1.0;
        notifyListeners();
      }

      // 최종 병합 및 커버 맨 앞으로
      final merged = <String>[...existing, ...uploadedKeys];
      if (merged.isNotEmpty &&
          coverIndexCombined >= 0 &&
          coverIndexCombined < merged.length) {
        final coverKey = merged.removeAt(coverIndexCombined);
        merged.insert(0, coverKey);
      }

      setFields({
        'photos.urls': merged, // 서버 저장용(키/URL 혼재 가능)
        'photos.localPaths': const <String>[],
        'photos.count': merged.length,
      });

      // 프리뷰 URL
      final preview = await _s3.viewUrlsForKeys(merged);
      setFields({'photos.previewUrls': preview});

      return true;
    } catch (e) {
      photoUploadError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> submit() async {
    if (isSubmitting) return false;
    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      final req = _buildRequestFromForm();
      lastRequest = req;

      if (_editing) {
        await _service.updateListing(_editingId!, req);
      } else {
        await _service.createTourReq(req);
      }

      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      submitError = e.toString();
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // ----------------- Request 빌더 -----------------
  TourCreateRequest _buildRequestFromForm() {
    String yn(bool? v) => (v ?? false) ? 'Y' : 'N';

    final keywords =
        (getField<List>('keywords.selected') ?? const <dynamic>[])
            .map((e) => e.toString())
            .toList();

    final title = (getField<String>('basic.title') ?? '').trim();
    final introduce = (getField<String>('basic.description') ?? '').trim();

    String _mergeLines(String? textKey, String? listKey) {
      final t = (getField<String>(textKey ?? '') ?? '').trim();
      final list =
          (getField<List>(listKey ?? '') ?? const [])
              .map((e) => e.toString().trim())
              .where((e) => e.isNotEmpty)
              .toList();
      if (t.isNotEmpty) return t;
      if (list.isNotEmpty) return list.join('\n');
      return '';
    }

    final includedText = _mergeLines('includes.text', 'includes.list');
    final excludedText = _mergeLines('excludes.text', 'excludes.list');

    final meetAddr = getField<String>('meet.state');
    final lat = getField<double>('meet.lat');
    final lng = getField<double>('meet.lng');
    final locCode = getField<int>('meet.locationCode');

    // 서버로 보내는 소스: photos.urls (키/URL)
    final photoUrls = <String>[
      ...(getField<List>('photos.urls') ?? const <dynamic>[]).map(
        (e) => e.toString(),
      ),
    ];
    if (photoUrls.isEmpty) {
      photoUrls.addAll(
        (getField<List>('photos.localPaths') ?? const <dynamic>[]).map(
          (e) => e.toString(),
        ),
      );
    }
    // 서버에서 내려온 파일 유지
    final files =
        (getField<List>('photos.files') ?? const <dynamic>[])
            .map((e) => e.toString())
            .toList();
    for (final f in files) {
      if (!photoUrls.contains(f)) photoUrls.add(f);
    }
    final thumbnail = photoUrls.isNotEmpty ? photoUrls.first : null;

    final basic = getField<int>('pricing.basic') ?? 0;
    final premium = getField<int>('pricing.premiumMin');
    final hasPrivate = premium != null && premium > 0;

    final drive = getField<bool>('provision.driveGuests');
    final visit = getField<bool>('provision.visitAttractions');
    final explain = getField<bool>('provision.explainHistory');

    final memo =
        '관광명소 방문:${visit == null ? '미응답' : (visit ? '예' : '아니요')} '
        '역사 설명:${explain == null ? '미응답' : (explain ? '예' : '아니요')}';

    final rawList = getField<List>('itinerary.items');
    final activities = <ActivityCreateReq>[];
    if (rawList != null) {
      for (var i = 0; i < rawList.length; i++) {
        final m = Map<String, dynamic>.from(rawList[i] as Map);

        final order = (m['order'] ?? m['activityOrder'] ?? (i + 1)) as int;

        final aTitle = (m['title'] ?? m['activityTitle'])?.toString();
        final aIntro =
            (m['intro'] ?? m['activityIntroduce'] ?? m['note'])?.toString();

        final dur =
            (m['durationMin'] ?? m['activityDurationMinute'] ?? m['minutes'])
                as int?;

        final rawThumbs =
            (m['thumbs'] ??
                    m['thumbnailUrls'] ??
                    (m['photoPath'] != null ? [m['photoPath']] : const []))
                as List?;
        final thumbs =
            (rawThumbs ?? const []).map((e) => e.toString()).toList();

        if (aTitle == null) continue;

        activities.add(
          ActivityCreateReq(
            activityOrder: order,
            activityTitle: aTitle,
            activityIntroduce: aIntro,
            activityDurationMinute: dur,
            thumbnails: List.generate(
              thumbs.length,
              (idx) => ActivityThumbCreateReq(
                thumbnailOrder: idx + 1,
                thumbnailImageUrl: thumbs[idx],
              ),
            ),
          ),
        );
      }
    }

    return TourCreateRequest(
      tourKeywords: keywords,
      tourTitle: title,
      tourIntroduce: introduce,
      tourIncludedContent: includedText,
      tourExcludedContent: excludedText,
      tourNotes: getField<String>('meet.placeLabel'),
      tourLocationCode: locCode,
      tourThumbnailUrl: thumbnail,
      tourPrice: basic,
      minHeadCount: getField<int>('people.min'),
      maxHeadCount: getField<int>('people.max'),
      meetUpAddress: meetAddr,
      meetUpLat: lat,
      meetUpLng: lng,
      transportServiceFlag: yn(drive),
      privateFlag: hasPrivate ? 'Y' : 'N',
      privatePrice: hasPrivate ? premium : null,
      adultContentFlag: 'N',
      tourStatusCode: '100001',
      memo: memo,
      activities: activities,
      photos: photoUrls,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_create_request.dart';
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
  String? _editingId; // 리스팅/투어 ID (서버 키, 문자열로 통일)
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

      // 실제 응답 키에 맞게 수정
      final title = _gs(detail, 'tourTitle') ?? '';
      final introduce = _gs(detail, 'tourIntroduce') ?? '';
      final notes = _gs(detail, 'tourNotes'); // meet.placeLabel
      final meetAddr = _gs(detail, 'meetUpAddress'); // meet.state
      final meetLat = _gd(detail, 'meetUpLat');
      final meetLng = _gd(detail, 'meetUpLng');
      final locationCode = _gi(detail, 'tourLocationCode');

      final photos = _glAsString(detail, 'photos'); // 원격 URL 배열
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
        // 기본 정보
        'basic.title': title.trim(),
        'basic.description': introduce.trim(),

        // 만남 장소/주소
        'meet.placeLabel': notes ?? '',
        'meet.state': meetAddr ?? '',
        'meet.road': '',
        'meet.detail': '',
        'meet.lat': meetLat,
        'meet.lng': meetLng,
        'meet.locationCode': locationCode,

        // 사진
        'photos.files': photos,

        // 일정표
        'itinerary.items': _mapActivitiesFromMap(activities),
        'itinerary.count': activities.length,

        // 가격
        'pricing.basic': price,
        'pricing.premiumMin': (privateFlag == 'Y') ? (privatePrice ?? 0) : 0,

        // 키워드
        'keywords.selected': keywords,

        // 인원
        'people.min': minHead,
        'people.max': maxHead,

        // 제공/세부정보
        'provision.driveGuests': _ynToBool(transportYN),
        'provision.visitAttractions': _inferVisit(memo),
        'provision.explainHistory': _inferExplain(memo),
      });
    } catch (e) {
      detailError = e;
    } finally {
      loadingDetail = false;
      notifyListeners();
    }
  }

  // 메모 문자열에서 방문/설명 여부 추론 (없으면 null 유지)
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

  // 서버 activities(맵 리스트) → 폼 아이템으로 변환
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

      // 썸네일/이미지 경로 수집
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

  /// 신규/수정 통합 제출
  Future<bool> submit() async {
    if (isSubmitting) return false;
    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      final req = _buildRequestFromForm();
      lastRequest = req;

      if (_editing) {
        // ✅ 수정 (id는 String으로 사용)
        await _service.updateListing(_editingId!, req);
      } else {
        // ✅ 신규 생성
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
    // 서버에서 내려온 원격 파일 유지
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

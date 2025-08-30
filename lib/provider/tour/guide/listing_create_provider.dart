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
  final List<ListingStepConfig> steps;
  final VoidCallback? onStart;
  final TourService _service;

  ListingCreateProvider({
    required this.steps,
    this.onStart,
    TourService? service,
  }) : _service = service ?? TourService(),
       assert(steps.isNotEmpty);

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
    if (guard == null)
      _nextGuards.remove(stepId);
    else
      _nextGuards[stepId] = guard;
  }

  Future<void> nextWithGuard() async {
    final guard = _nextGuards[currentId];
    if (guard != null) {
      final ok = await guard();
      if (!ok) return;
    }
    next();
  }

  bool isSubmitting = false;
  String? submitError;
  TourCreateRequest? lastRequest;

  Future<bool> submit() async {
    if (isSubmitting) return false;
    isSubmitting = true;
    submitError = null;
    notifyListeners();
    try {
      final req = _buildRequestFromForm();
      lastRequest = req;
      await _service.createTourReq(req);
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

  TourCreateRequest _buildRequestFromForm() {
    String yn(bool? v) => (v ?? false) ? 'Y' : 'N';

    // 키워드
    final keywords =
        (getField<List>('keywords.selected') ?? const <dynamic>[])
            .map((e) => e.toString())
            .toList();

    // 기본 정보
    final title = (getField<String>('basic.title') ?? '').trim();
    final introduce = (getField<String>('basic.description') ?? '').trim();

    // 포함/불포함 텍스트 (list가 있으면 줄바꿈으로 합침)
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

    // 위치
    final meetAddr =
        getField<String>('meet.address') ?? getField<String>('meet.placeName');
    final lat = getField<double>('meet.lat');
    final lng = getField<double>('meet.lng');
    final locCode = getField<int>('meet.locationCode');

    // 사진 (URL 우선)
    final photoUrls =
        (getField<List>('photos.urls') ?? const <dynamic>[])
            .map((e) => e.toString())
            .toList();
    final thumbnail = photoUrls.isNotEmpty ? photoUrls.first : null;

    // 가격
    final basic = getField<int>('pricing.basic') ?? 0;
    final premium = getField<int>('pricing.premiumMin');
    final hasPrivate = premium != null && premium > 0;

    // 세부 정보
    final drive = getField<bool>('provision.driveGuests');
    final visit = getField<bool>('provision.visitAttractions');
    final explain = getField<bool>('provision.explainHistory');
    final memo =
        '관광명소 방문:${visit == null ? '미응답' : (visit ? '예' : '아니요')} '
        '역사 설명:${explain == null ? '미응답' : (explain ? '예' : '아니요')}';

    // 일정표
    final rawItems =
        (getField<List>('itinerary.items') ?? const <dynamic>[]).cast<Map>();
    final activities = <ActivityCreateReq>[];
    for (final m in rawItems) {
      final order = (m['order'] ?? m['activityOrder']) as int?;
      final aTitle = (m['title'] ?? m['activityTitle'])?.toString();
      final aIntro = (m['intro'] ?? m['activityIntroduce'])?.toString();
      final dur = (m['durationMin'] ?? m['activityDurationMinute']) as int?;
      final thumbs =
          ((m['thumbs'] ?? m['thumbnailUrls']) as List? ?? const [])
              .map((e) => e.toString())
              .toList();

      if (order == null || aTitle == null) continue;

      activities.add(
        ActivityCreateReq(
          activityOrder: order,
          activityTitle: aTitle,
          activityIntroduce: aIntro,
          activityDurationMinute: dur,
          thumbnails: List.generate(
            thumbs.length,
            (i) => ActivityThumbCreateReq(
              thumbnailOrder: i + 1,
              thumbnailImageUrl: thumbs[i],
            ),
          ),
        ),
      );
    }

    return TourCreateRequest(
      tourKeywords: keywords,
      tourTitle: title,
      tourIntroduce: introduce,
      tourIncludedContent: includedText,
      tourExcludedContent: excludedText,
      tourNotes: getField<String>('notes'),
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

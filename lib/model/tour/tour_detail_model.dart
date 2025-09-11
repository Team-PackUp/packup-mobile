import 'package:packup/model/guide/guide_model.dart';

class TourDetailModel {
  final int seq;
  final String title;
  final GuideModel? guide;
  final List<String> imageUrl;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final String description;
  final String duration;
  final List<String> languages;
  final List<String> includeItems;
  final List<String> excludeItems;

  final int price;

  final int? privatePrice;

  final String? privateFlag;

  bool get privateAvailable => _isYes(privateFlag) || ((privatePrice ?? 0) > 0);

  const TourDetailModel({
    required this.seq,
    required this.title,
    required this.imageUrl,
    this.guide,
    required this.rating,
    required this.reviewCount,
    required this.tags,
    required this.description,
    required this.duration,
    required this.languages,
    required this.includeItems,
    required this.excludeItems,
    required this.price,
    this.privatePrice,
    this.privateFlag,
  });

  factory TourDetailModel.fromJson(Map<String, dynamic> r) {
    final seq = (r['seq'] as num).toInt();
    final guideMap = r['guide'];

    final GuideModel? guide =
        (guideMap is Map<String, dynamic>)
            ? GuideModel.fromJson(guideMap)
            : null;

    final String? thumbnail = r['tourThumbnailUrl'] as String?;
    final List<String> languages = _splitToList(guide?.languages);
    final List<String> includeItems = _splitToList(r['tourIncludedContent']);
    final List<String> excludeItems = _splitToList(r['tourExcludedContent']);

    final String? privateFlag = r['privateFlag']?.toString();
    final int? privatePrice =
        (r['privatePrice'] == null) ? null : _toInt(r['privatePrice']);

    final List<String> tags = <String>[
      if (_toStringSafe(r['tourStatusLabel']).isNotEmpty)
        _toStringSafe(r['tourStatusLabel']),
      if (_isYes(r['transportServiceFlag'])) 'Transport',
      if (_isYes(privateFlag)) 'Private',
      if (_isYes(r['adultContentFlag'])) 'Adult',
      if (r['tourLocationCode'] != null) 'Loc:${r['tourLocationCode']}',
    ];

    final String notes = _toStringSafe(r['tourNotes']);
    final String duration = _extractDuration(notes);

    return TourDetailModel(
      seq: seq,
      title: _toStringSafe(r['tourTitle']),
      guide: guide,
      imageUrl: [
        if (thumbnail != null && thumbnail.trim().isNotEmpty) thumbnail,
      ],
      rating: 0.0,
      reviewCount: 0,
      tags: tags,
      description: _toStringSafe(r['tourIntroduce']),
      duration: duration,
      languages: languages,
      includeItems: includeItems,
      excludeItems: excludeItems,
      price: _toInt(r['tourPrice']),
      privatePrice: privatePrice,
      privateFlag: privateFlag,
    );
  }

  static TourDetailModel mock() {
    return const TourDetailModel(
      seq: 9,
      title: '인사동 & 북촌 걷기 투어',
      imageUrl: [
        'assets/image/background/jeonju.jpg',
        'assets/image/background/busan.jpg',
        'assets/image/background/daejeon.jpg',
        'assets/image/background/IMG_5607.GIF',
      ],
      rating: 4.8,
      reviewCount: 150,
      tags: ['Culture', 'History', 'Walking Tour', 'Seoul', 'Private'],
      description:
          '돈벌고싶어? 대기업가고싶어? 뭐해? PACK-UP 안하고? 완벽한 프로젝트 팩업 지금바로 시작 - PlayStore',
      duration: '1년',
      languages: ['영어', '준모어', '중국어'],
      includeItems: [
        '플러터의신 임준아',
        '데이터베이스 설계의 대가 이솔빈',
        '사업기획 및 시스템 기획 전문가 박민석',
        '그냥 정준모',
      ],
      excludeItems: ['개발자 월급', '개발자 워라밸', '잠자는 시간'],
      price: 55000,
      privatePrice: 120000,
      privateFlag: 'Y',
    );
  }
}

int _toInt(dynamic v, {int defaultValue = 0}) {
  if (v == null) return defaultValue;
  if (v is int) return v;
  if (v is num) return v.toInt();
  final n = int.tryParse(v.toString());
  return n ?? defaultValue;
}

String _toStringSafe(dynamic v) => (v == null) ? '' : v.toString();

bool _isYes(dynamic v) {
  if (v == null) return false;
  final s = v.toString().toUpperCase();
  return s == 'Y' || s == 'YES' || s == 'TRUE' || s == 'T' || s == '1';
}

List<String> _splitToList(dynamic raw) {
  final s = _toStringSafe(raw);
  if (s.isEmpty) return const [];
  final parts =
      s
          .split(RegExp(r'[,;\n•|]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
  return parts.toSet().toList();
}

String _extractDuration(String notes) {
  if (notes.isEmpty) return '';
  final candidates = <RegExp>[
    RegExp(r'(소요\s*시간|소요시간)\s*[:：]?\s*([0-9]+(?:\.[0-9]+)?\s*(?:시간|분))'),
    RegExp(
      r'(Duration)\s*[:：]?\s*([0-9]+(?:\.[0-9]+)?\s*(?:h|hr|hours|mins|minutes))',
      caseSensitive: false,
    ),
    RegExp(r'약?\s*([0-9]+(?:\.[0-9]+)?\s*(?:시간|분))'),
  ];
  for (final re in candidates) {
    final m = re.firstMatch(notes);
    if (m != null) {
      return m.group(m.groupCount) ?? '';
    }
  }
  return '';
}

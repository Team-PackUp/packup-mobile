class TourDetailModel {
  final String title;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final String description;
  final String duration;
  final List<String> languages;
  final List<String> includeItems;

  const TourDetailModel({
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.tags,
    required this.description,
    required this.duration,
    required this.languages,
    required this.includeItems,
  });

  static TourDetailModel mock() {
    return TourDetailModel(
      title: '인사동 & 북촌 걷기 투어',
      imageUrl: 'assets/image/background/jeonju.jpg',
      rating: 4.8,
      reviewCount: 150,
      tags: ['Culture', 'History', 'Walking Tour', 'Seoul'],
      description:
          '돈벌고싶어? 대기업가고싶어? 뭐해? PACK-UP 안하고? 완벽한 프로젝트 팩업 지금바로 시작 - PlayStore',
      duration: '1년',
      languages: ['영어', '준모어', '중국어'],
      includeItems: ['플러터의신 임준아', '데이터베이스 설계의 대가 이솔빈', '사업기획 및 시스템 기획 전문가 박민석'],
    );
  }
}

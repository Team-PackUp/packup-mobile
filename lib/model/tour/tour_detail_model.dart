class TourDetailModel {
  final String title;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final String description;
  final String duration;
  final List<String> languages;

  const TourDetailModel({
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.tags,
    required this.description,
    required this.duration,
    required this.languages,
  });
}

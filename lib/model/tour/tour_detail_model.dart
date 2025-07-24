class TourDetailModel {
  final String title;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<String> tags;

  const TourDetailModel({
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.tags,
  });
}

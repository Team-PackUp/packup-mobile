class GuideRatingModelTemp {
  final double average;
  final int totalCount;
  final Map<int, double> ratingDistribution;

  const GuideRatingModelTemp({
    required this.average,
    required this.totalCount,
    required this.ratingDistribution,
  });

  factory GuideRatingModelTemp.mock() {
    return const GuideRatingModelTemp(
      average: 4.4,
      totalCount: 5,
      ratingDistribution: {5: 0.5, 4: 0.1, 3: 0.2, 2: 0.1, 1: 0.1},
    );
  }

  factory GuideRatingModelTemp.fromJson(Map<String, dynamic> json) {
    return GuideRatingModelTemp(
      average: (json['average'] as num).toDouble(),
      totalCount: json['totalCount'],
      ratingDistribution: Map<int, double>.from(
        (json['ratingDistribution'] as Map).map(
          (key, value) => MapEntry(int.parse(key), (value as num).toDouble()),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'totalCount': totalCount,
      'ratingDistribution': ratingDistribution.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
    };
  }
}

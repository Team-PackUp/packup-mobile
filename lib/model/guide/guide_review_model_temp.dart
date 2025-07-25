class GuideReviewModelTemp {
  final String name;
  final String imageUrl;
  final int rating;
  final String content;
  final String date;
  final String? tourTitle;

  const GuideReviewModelTemp({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.content,
    required this.date,
    this.tourTitle,
  });

  factory GuideReviewModelTemp.mock1() {
    return const GuideReviewModelTemp(
      name: 'Juna Im',
      imageUrl: 'https://i.pravatar.cc/150?img=5',
      rating: 5,
      content: '팩업은 언제 끝날까요?',
      date: '2023-10-26',
      tourTitle: '광장시장 푸드 투어',
    );
  }

  factory GuideReviewModelTemp.mock2() {
    return const GuideReviewModelTemp(
      name: 'Minseok Park',
      imageUrl: 'https://i.pravatar.cc/150?img=10',
      rating: 2,
      content: '안녕하세요 정준모입니다.',
      date: '2023-10-20',
      tourTitle: '서울 개발자 역사 탐방',
    );
  }

  factory GuideReviewModelTemp.fromJson(Map<String, dynamic> json) {
    return GuideReviewModelTemp(
      name: json['name'],
      imageUrl: json['imageUrl'],
      rating: json['rating'],
      content: json['content'],
      date: json['date'],
      tourTitle: json['tourTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'content': content,
      'date': date,
      'tourTitle': tourTitle,
    };
  }
}

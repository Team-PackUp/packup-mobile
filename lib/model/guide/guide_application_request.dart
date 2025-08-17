class GuideApplicationRequest {
  final String selfIntro;
  final String idImageUrl;

  GuideApplicationRequest({required this.selfIntro, required this.idImageUrl});

  Map<String, dynamic> toJson() => {
    "selfIntro": selfIntro,
    "idImageUrl": idImageUrl,
  };
}

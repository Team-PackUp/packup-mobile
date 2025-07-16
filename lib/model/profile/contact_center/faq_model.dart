class FaqModel {
  final int? seq;
  final String? answer;
  final String? question;
  final String? faqType;

  FaqModel({
    this.seq,
    this.answer,
    this.question,
    this.faqType,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      seq: json['seq'],
      answer: json['answer'],
      question: json['question'],
      faqType: json['faqType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'answer': answer,
      'question': question,
      'faqType': faqType,
    };
  }
}

enum AlertType { orderDone, dataEdited, system }

class AlertCenterModel {
  final String seq;
  final AlertType alertType;
  final String title;
  final String content;
  final DateTime createdAt;
  bool isRead;

  AlertCenterModel({
    required this.seq,
    required this.alertType,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isRead = false,
  });

  factory AlertCenterModel.fromJson(Map<String, dynamic> j) => AlertCenterModel(
    seq: j['seq'],
    alertType: AlertType.values.byName(j['alertType']),
    title: j['title'],
    content: j['content'],
    createdAt: DateTime.parse(j['createdAt']),
    isRead: j['isRead'] ?? false,
  );
}

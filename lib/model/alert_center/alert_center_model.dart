import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


enum AlertType {
  RESERVATION_COMPLETE,
  RESERVATION_MODIFIED,
  RESERVATION_CANCEL,
  ADVERTISE,
  NEW_NOTIFICATION,
}

extension AlertTypeMessage on AlertType {
  String message(BuildContext context, {String? item}) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case AlertType.RESERVATION_COMPLETE:
        return l10n.reservation_complete(item ?? '');
      case AlertType.RESERVATION_MODIFIED:
        return l10n.reservation_modified(item ?? '');
      case AlertType.RESERVATION_CANCEL:
        return l10n.reservation_cancel(item ?? '');

      case AlertType.ADVERTISE:
        return l10n.advertise;
      case AlertType.NEW_NOTIFICATION:
        return l10n.new_notification;
    }
  }
}



class AlertCenterModel {
  final int seq;
  final AlertType alertType;
  final DateTime createdAt;
  final String? payload;
  bool isRead;

  AlertCenterModel({
    required this.seq,
    required this.alertType,
    required this.createdAt,
    this.payload,
    this.isRead = false,
  });

  factory AlertCenterModel.fromJson(Map<String, dynamic> j) => AlertCenterModel(
    seq: j['seq'],
    alertType: AlertType.values.byName(j['alertType']),
    createdAt: DateTime.parse(j['createdAt']),
    payload: j['payload'] ?? '',
    isRead: j['isRead'] ?? false,
  );
}

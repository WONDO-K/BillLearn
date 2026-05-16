import 'package:billlearn/src/domain/models/raw_notification.dart';

enum ParseStatus { parsed, unsupported, failed }

class TransactionCandidate {
  const TransactionCandidate({
    required this.id,
    required this.rawNotificationId,
    required this.amount,
    required this.merchantName,
    required this.paymentMethodHint,
    required this.occurredAt,
    required this.sourceType,
    required this.parseConfidence,
    required this.parseStatus,
    required this.createdAt,
  });

  final String id;
  final String rawNotificationId;
  final int amount;
  final String merchantName;
  final String? paymentMethodHint;
  final DateTime occurredAt;
  final RawNotificationSourceType sourceType;
  final double parseConfidence;
  final ParseStatus parseStatus;
  final DateTime createdAt;
}

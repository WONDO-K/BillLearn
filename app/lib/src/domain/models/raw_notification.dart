enum RawNotificationSourceType { push, sms }

class RawNotification {
  const RawNotification({
    required this.id,
    required this.sourceType,
    required this.sourceApp,
    required this.sender,
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.sourceHash,
    required this.createdAt,
  });

  final String id;
  final RawNotificationSourceType sourceType;
  final String? sourceApp;
  final String? sender;
  final String? title;
  final String body;
  final DateTime receivedAt;
  final String sourceHash;
  final DateTime createdAt;
}

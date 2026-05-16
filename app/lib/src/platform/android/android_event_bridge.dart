import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:flutter/services.dart';

class AndroidEventBridge {
  static const methodChannel = MethodChannel('billlearn.android/methods');
  static const eventChannel = EventChannel('billlearn.android/raw_events');

  Stream<RawNotification> watchRawNotifications() {
    return eventChannel.receiveBroadcastStream().map((event) {
      return rawNotificationFromPayload(
        Map<String, Object?>.from(event as Map),
      );
    });
  }

  Future<bool> isNotificationAccessEnabled() async {
    return await methodChannel.invokeMethod<bool>(
          'isNotificationAccessEnabled',
        ) ??
        false;
  }

  Future<void> openNotificationAccessSettings() async {
    await methodChannel.invokeMethod<void>('openNotificationAccessSettings');
  }

  static RawNotification rawNotificationFromPayload(
    Map<String, Object?> payload,
  ) {
    final sourceTypeText = payload['sourceType'] as String;
    return RawNotification(
      id: payload['id'] as String,
      sourceType: sourceTypeText == 'sms'
          ? RawNotificationSourceType.sms
          : RawNotificationSourceType.push,
      sourceApp: payload['sourceApp'] as String?,
      sender: payload['sender'] as String?,
      title: payload['title'] as String?,
      body: payload['body'] as String,
      receivedAt: DateTime.fromMillisecondsSinceEpoch(
        payload['receivedAtMillis'] as int,
      ),
      sourceHash: payload['sourceHash'] as String,
      createdAt: DateTime.now(),
    );
  }
}

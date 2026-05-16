import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/platform/android/android_event_bridge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(AndroidEventBridge.methodChannel, null);
  });

  test('maps Android event payload into raw notification', () {
    final raw = AndroidEventBridge.rawNotificationFromPayload({
      'id': 'raw-1',
      'sourceType': 'sms',
      'sourceApp': null,
      'sender': '1588-0000',
      'title': null,
      'body': '[승인] 12,300원 스타벅스',
      'receivedAtMillis': DateTime(2026, 5, 14, 12, 30).millisecondsSinceEpoch,
      'sourceHash': 'hash-1',
    });

    expect(raw.sourceType, RawNotificationSourceType.sms);
    expect(raw.sender, '1588-0000');
    expect(raw.body, contains('스타벅스'));
  });

  test('checks and requests sms permission through method channel', () async {
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(AndroidEventBridge.methodChannel, (
          call,
        ) async {
          calls.add(call.method);
          return true;
        });

    final bridge = AndroidEventBridge();

    expect(await bridge.isSmsPermissionGranted(), isTrue);
    expect(await bridge.requestSmsPermission(), isTrue);
    expect(calls, ['isSmsPermissionGranted', 'requestSmsPermission']);
  });
}

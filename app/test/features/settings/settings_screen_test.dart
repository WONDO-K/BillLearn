import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/features/settings/settings_screen.dart';
import 'package:billlearn/src/platform/android/android_event_bridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows notification access status and opens settings', (
    tester,
  ) async {
    final bridge = _FakeAndroidEventBridge(
      notificationAccessEnabled: false,
      smsPermissionGranted: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [androidEventBridgeProvider.overrideWithValue(bridge)],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('알림 접근 권한'), findsOneWidget);
    expect(find.text('꺼짐'), findsOneWidget);

    await tester.tap(find.text('설정 열기'));
    await tester.pump();

    expect(bridge.openNotificationSettingsCallCount, 1);
  });

  testWidgets('shows sms permission status and requests permission', (
    tester,
  ) async {
    final bridge = _FakeAndroidEventBridge(
      notificationAccessEnabled: true,
      smsPermissionGranted: false,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [androidEventBridgeProvider.overrideWithValue(bridge)],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('SMS 권한'), findsOneWidget);
    expect(find.text('꺼짐'), findsOneWidget);

    await tester.tap(find.text('SMS 권한 요청'));
    await tester.pump();

    expect(bridge.requestSmsPermissionCallCount, 1);
  });
}

class _FakeAndroidEventBridge extends AndroidEventBridge {
  _FakeAndroidEventBridge({
    required this.notificationAccessEnabled,
    required this.smsPermissionGranted,
  });

  final bool notificationAccessEnabled;
  final bool smsPermissionGranted;
  int openNotificationSettingsCallCount = 0;
  int requestSmsPermissionCallCount = 0;

  @override
  Future<bool> isNotificationAccessEnabled() async {
    return notificationAccessEnabled;
  }

  @override
  Future<void> openNotificationAccessSettings() async {
    openNotificationSettingsCallCount += 1;
  }

  @override
  Future<bool> isSmsPermissionGranted() async {
    return smsPermissionGranted;
  }

  @override
  Future<bool> requestSmsPermission() async {
    requestSmsPermissionCallCount += 1;
    return true;
  }
}

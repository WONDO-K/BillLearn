import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/data/repositories/in_memory_expense_repository.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
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
    final repository = InMemoryExpenseRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          androidEventBridgeProvider.overrideWithValue(bridge),
          expenseRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('알림 접근 권한'), findsOneWidget);
    expect(find.text('꺼짐'), findsOneWidget);

    await tester.tap(find.text('설정 열기'));
    await tester.pump();

    expect(bridge.openNotificationSettingsCallCount, 1);

    await repository.dispose();
  });

  testWidgets('shows sms permission status and requests permission', (
    tester,
  ) async {
    final bridge = _FakeAndroidEventBridge(
      notificationAccessEnabled: true,
      smsPermissionGranted: false,
    );
    final repository = InMemoryExpenseRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          androidEventBridgeProvider.overrideWithValue(bridge),
          expenseRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('SMS 권한'), findsOneWidget);
    expect(find.text('꺼짐'), findsOneWidget);

    await tester.tap(find.text('SMS 권한 요청'));
    await tester.pump();

    expect(bridge.requestSmsPermissionCallCount, 1);

    await repository.dispose();
  });

  testWidgets('shows raw notification collection diagnostics', (tester) async {
    final bridge = _FakeAndroidEventBridge(
      notificationAccessEnabled: true,
      smsPermissionGranted: true,
    );
    final repository = InMemoryExpenseRepository();
    await repository.saveRawNotification(
      RawNotification(
        id: 'raw-1',
        sourceType: RawNotificationSourceType.sms,
        sourceApp: null,
        sender: '1588-0000',
        title: null,
        body: '[신한카드 승인] 12,300원 스타벅스',
        receivedAt: DateTime(2026, 5, 14, 12, 30),
        sourceHash: 'hash-raw-1',
        createdAt: DateTime(2026, 5, 14, 12, 30),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          androidEventBridgeProvider.overrideWithValue(bridge),
          expenseRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('수집 진단'), findsOneWidget);
    expect(find.text('최근 수집 1건'), findsOneWidget);
    expect(find.text('마지막 수집'), findsOneWidget);
    expect(find.text('[신한카드 승인] 12,300원 스타벅스'), findsOneWidget);

    await repository.dispose();
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

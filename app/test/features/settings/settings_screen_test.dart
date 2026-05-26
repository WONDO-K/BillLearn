import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/data/repositories/in_memory_expense_repository.dart';
import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
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
        child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
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
        child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
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
    await repository.saveTransactionCandidate(
      TransactionCandidate(
        id: 'candidate-raw-1',
        rawNotificationId: 'raw-1',
        amount: 12300,
        merchantName: '스타벅스',
        paymentMethodHint: '신한카드',
        occurredAt: DateTime(2026, 5, 14, 12, 30),
        sourceType: RawNotificationSourceType.sms,
        parseConfidence: 0.9,
        parseStatus: ParseStatus.parsed,
        createdAt: DateTime(2026, 5, 14, 12, 30),
      ),
    );
    await repository.saveClassificationResult(
      ClassificationResult(
        id: 'classification-raw-1',
        candidateIds: const ['candidate-raw-1'],
        isDuplicate: false,
        isTransferLike: false,
        isExpense: true,
        requiresReview: false,
        reasonCodes: const ['stable_payment_signal'],
        confidence: 0.9,
        createdAt: DateTime(2026, 5, 14, 12, 30),
        userFeedback: null,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          androidEventBridgeProvider.overrideWithValue(bridge),
          expenseRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump();

    await tester.scrollUntilVisible(find.text('수집 진단'), 300);
    expect(find.text('수집 진단'), findsOneWidget);
    expect(find.text('최근 수집 1건'), findsOneWidget);
    expect(find.text('마지막 수집'), findsOneWidget);
    expect(find.text('[신한카드 승인] 12,300원 스타벅스'), findsOneWidget);
    expect(find.text('파싱 결과'), findsOneWidget);
    expect(find.text('스타벅스 · 12,300원'), findsOneWidget);
    expect(find.text('판별 결과'), findsOneWidget);
    expect(find.text('실제 지출 · 신뢰도 90%'), findsOneWidget);
    expect(find.text('stable_payment_signal'), findsOneWidget);

    await repository.dispose();
  });

  testWidgets('creates debug sample transactions from settings', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() async => tester.binding.setSurfaceSize(null));

    final bridge = _FakeAndroidEventBridge(
      notificationAccessEnabled: true,
      smsPermissionGranted: true,
    );
    final repository = InMemoryExpenseRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          androidEventBridgeProvider.overrideWithValue(bridge),
          expenseRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('개발자 도구'), findsOneWidget);
    expect(find.text('대기 중 원천 이벤트 2건'), findsOneWidget);
    expect(find.text('샘플 거래 생성'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('샘플 거래 생성'), 120);
    await tester.tap(find.text('샘플 거래 생성'));
    await tester.pump();

    final expenses = await repository.getExpenses();
    expect(expenses, hasLength(3));
    expect(
      expenses.map((expense) => expense.merchantName),
      containsAll(['배달의민족', '동백전 충전', '스타벅스']),
    );
    expect(find.text('샘플 거래를 생성했습니다'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('샘플 거래 생성'), 120);
    await tester.tap(find.text('샘플 거래 생성'));
    await tester.pump();

    final reseededExpenses = await repository.getExpenses();
    expect(reseededExpenses, hasLength(3));

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
  final int pendingRawEventCount = 2;
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

  @override
  Future<int> getPendingRawEventCount() async {
    return pendingRawEventCount;
  }
}

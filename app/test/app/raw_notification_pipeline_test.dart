import 'dart:async';

import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/data/repositories/in_memory_expense_repository.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'processes Android raw notification stream into stored expense',
    () async {
      final rawEvents = StreamController<RawNotification>();
      final pendingEvents = _FakePendingRawEvents();
      final repository = InMemoryExpenseRepository();
      final container = ProviderContainer(
        overrides: [
          expenseRepositoryProvider.overrideWithValue(repository),
          rawNotificationStreamProvider.overrideWithValue(rawEvents.stream),
          pendingRawNotificationsProvider.overrideWithValue(pendingEvents.call),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(rawEvents.close);
      addTearDown(repository.dispose);

      final pipeline = container.listen(
        rawNotificationPipelineProvider,
        (_, __) {},
      );
      addTearDown(pipeline.close);
      await Future<void>.delayed(Duration.zero);

      expect(rawEvents.hasListener, isTrue);

      rawEvents.add(
        RawNotification(
          id: 'raw-1',
          sourceType: RawNotificationSourceType.sms,
          sourceApp: null,
          sender: '1588-0000',
          title: null,
          body: '[신한카드 승인] 12,300원 스타벅스 05/14 12:30',
          receivedAt: DateTime(2026, 5, 14, 12, 31),
          sourceHash: 'hash-1',
          createdAt: DateTime(2026, 5, 14, 12, 31),
        ),
      );

      final rawNotification = await _waitForRawNotification(
        repository,
        'hash-1',
      );
      final expenses = await _waitForExpenses(repository);

      expect(rawNotification?.id, 'raw-1');
      expect(expenses.single.merchantName, '스타벅스');
      expect(expenses.single.amount, 12300);
      expect(expenses.single.confirmationStatus, ConfirmationStatus.confirmed);
    },
  );

  test('processes pending Android raw notifications on startup', () async {
    final rawEvents = StreamController<RawNotification>();
    final pendingEvents = _FakePendingRawEvents([
      RawNotification(
        id: 'pending-raw-1',
        sourceType: RawNotificationSourceType.push,
        sourceApp: 'com.card.app',
        sender: null,
        title: '카드 승인',
        body: '[신한카드 승인] 12,300원 스타벅스 05/14 12:30',
        receivedAt: DateTime(2026, 5, 14, 12, 31),
        sourceHash: 'pending-hash-1',
        createdAt: DateTime(2026, 5, 14, 12, 31),
      ),
    ]);
    final repository = InMemoryExpenseRepository();
    final container = ProviderContainer(
      overrides: [
        expenseRepositoryProvider.overrideWithValue(repository),
        rawNotificationStreamProvider.overrideWithValue(rawEvents.stream),
        pendingRawNotificationsProvider.overrideWithValue(pendingEvents.call),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(rawEvents.close);
    addTearDown(repository.dispose);

    final pipeline = container.listen(
      rawNotificationPipelineProvider,
      (_, __) {},
    );
    addTearDown(pipeline.close);

    final rawNotification = await _waitForRawNotification(
      repository,
      'pending-hash-1',
    );
    final expenses = await _waitForExpenses(repository);

    expect(pendingEvents.callCount, 1);
    expect(rawNotification?.id, 'pending-raw-1');
    expect(expenses.single.merchantName, '스타벅스');
    expect(expenses.single.amount, 12300);
  });
}

class _FakePendingRawEvents {
  _FakePendingRawEvents([this.events = const []]);

  final List<RawNotification> events;
  int callCount = 0;

  Future<List<RawNotification>> call() async {
    callCount += 1;
    return events;
  }
}

Future<RawNotification?> _waitForRawNotification(
  InMemoryExpenseRepository repository,
  String sourceHash,
) async {
  for (var attempt = 0; attempt < 20; attempt += 1) {
    final rawNotification = await repository.getRawNotificationBySourceHash(
      sourceHash,
    );
    if (rawNotification != null) {
      return rawNotification;
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  return repository.getRawNotificationBySourceHash(sourceHash);
}

Future<List<ExpenseTransaction>> _waitForExpenses(
  InMemoryExpenseRepository repository,
) async {
  for (var attempt = 0; attempt < 20; attempt += 1) {
    final expenses = await repository.getExpenses();
    if (expenses.isNotEmpty) {
      return expenses;
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  return repository.getExpenses();
}

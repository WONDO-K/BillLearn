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
      final repository = InMemoryExpenseRepository();
      final container = ProviderContainer(
        overrides: [
          expenseRepositoryProvider.overrideWithValue(repository),
          rawNotificationStreamProvider.overrideWithValue(rawEvents.stream),
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

      final rawNotifications = await repository
          .watchRawNotifications()
          .firstWhere((items) => items.isNotEmpty);
      final expenses = await repository.watchExpenses().firstWhere(
        (items) => items.isNotEmpty,
      );

      expect(rawNotifications.single.id, 'raw-1');
      expect(expenses.single.merchantName, '스타벅스');
      expect(expenses.single.amount, 12300);
      expect(expenses.single.confirmationStatus, ConfirmationStatus.confirmed);
    },
  );
}

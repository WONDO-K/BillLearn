import 'dart:async';

import 'package:billlearn/src/data/local/app_database.dart';
import 'package:billlearn/src/data/repositories/local_expense_repository.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/repositories/expense_repository.dart';
import 'package:billlearn/src/domain/use_cases/process_raw_notification.dart';
import 'package:billlearn/src/platform/android/android_event_bridge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.open();
  ref.onDispose(database.close);
  return database;
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return LocalExpenseRepository(ref.watch(appDatabaseProvider));
});

final expensesProvider = StreamProvider<List<ExpenseTransaction>>((ref) {
  return ref.watch(expenseRepositoryProvider).watchExpenses();
});

final rawNotificationStreamProvider = Provider<Stream<RawNotification>>((ref) {
  return AndroidEventBridge().watchRawNotifications();
});

final processRawNotificationProvider = Provider<ProcessRawNotification>((ref) {
  return ProcessRawNotification(
    repository: ref.watch(expenseRepositoryProvider),
  );
});

final rawNotificationPipelineProvider =
    Provider<StreamSubscription<RawNotification>>((ref) {
      final processor = ref.watch(processRawNotificationProvider);
      final subscription = ref
          .watch(rawNotificationStreamProvider)
          .listen(processor.call);

      ref.onDispose(subscription.cancel);
      return subscription;
    });

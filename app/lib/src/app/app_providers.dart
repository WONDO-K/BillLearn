import 'dart:async';

import 'package:billlearn/src/data/local/app_database.dart';
import 'package:billlearn/src/data/repositories/local_expense_repository.dart';
import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:billlearn/src/domain/repositories/expense_repository.dart';
import 'package:billlearn/src/domain/use_cases/process_raw_notification.dart';
import 'package:billlearn/src/domain/use_cases/seed_debug_sample_data.dart';
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

final rawNotificationsProvider = StreamProvider<List<RawNotification>>((ref) {
  return ref.watch(expenseRepositoryProvider).watchRawNotifications();
});

final rawNotificationByIdProvider =
    FutureProvider.family<RawNotification?, String>((ref, id) {
      return ref.watch(expenseRepositoryProvider).getRawNotificationById(id);
    });

final expenseByIdProvider = FutureProvider.family<ExpenseTransaction?, String>((
  ref,
  id,
) {
  return ref.watch(expenseRepositoryProvider).getExpenseById(id);
});

final transactionCandidateByIdProvider =
    FutureProvider.family<TransactionCandidate?, String>((ref, id) {
      return ref
          .watch(expenseRepositoryProvider)
          .getTransactionCandidateById(id);
    });

final transactionCandidatesForRawNotificationProvider =
    FutureProvider.family<List<TransactionCandidate>, String>((
      ref,
      rawNotificationId,
    ) {
      return ref
          .watch(expenseRepositoryProvider)
          .getCandidatesForRawNotification(rawNotificationId);
    });

final classificationResultByCandidateIdProvider =
    FutureProvider.family<ClassificationResult?, String>((ref, candidateId) {
      return ref
          .watch(expenseRepositoryProvider)
          .getClassificationResultByCandidateId(candidateId);
    });

final androidEventBridgeProvider = Provider<AndroidEventBridge>((ref) {
  return AndroidEventBridge();
});

final rawNotificationStreamProvider = Provider<Stream<RawNotification>>((ref) {
  return ref.watch(androidEventBridgeProvider).watchRawNotifications();
});

final notificationAccessEnabledProvider = FutureProvider<bool>((ref) {
  return ref.watch(androidEventBridgeProvider).isNotificationAccessEnabled();
});

final smsPermissionGrantedProvider = FutureProvider<bool>((ref) {
  return ref.watch(androidEventBridgeProvider).isSmsPermissionGranted();
});

final processRawNotificationProvider = Provider<ProcessRawNotification>((ref) {
  return ProcessRawNotification(
    repository: ref.watch(expenseRepositoryProvider),
  );
});

final seedDebugSampleDataProvider = Provider<SeedDebugSampleData>((ref) {
  return SeedDebugSampleData(repository: ref.watch(expenseRepositoryProvider));
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

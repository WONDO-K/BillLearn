import 'package:billlearn/src/data/local/app_database.dart';
import 'package:billlearn/src/data/repositories/local_expense_repository.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('persists raw notifications and expenses in sqlite', () async {
    final database = AppDatabase.memory();
    final repository = LocalExpenseRepository(database);
    final raw = RawNotification(
      id: 'raw-1',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[승인] 12,300원 스타벅스',
      receivedAt: DateTime(2026, 5, 14, 12, 30),
      sourceHash: 'hash-1',
      createdAt: DateTime(2026, 5, 14, 12, 30),
    );
    final expense = ExpenseTransaction(
      id: 'expense-1',
      amount: 12300,
      merchantName: '스타벅스',
      categoryId: 'cafe',
      spentAt: DateTime(2026, 5, 14, 12, 30),
      confirmationStatus: ConfirmationStatus.confirmed,
      confirmedBy: ConfirmedBy.rule,
      candidateIds: const ['candidate-1', 'candidate-2'],
      createdAt: DateTime(2026, 5, 14, 12, 31),
      updatedAt: DateTime(2026, 5, 14, 12, 32),
      syncStatus: SyncStatus.localOnly,
    );

    await repository.saveRawNotification(raw);
    await repository.saveExpense(expense);

    final storedRaw = await repository.watchRawNotifications().first;
    final storedExpenses = await repository.watchExpenses().first;

    expect(storedRaw, hasLength(1));
    expect(storedRaw.single.id, raw.id);
    expect(storedRaw.single.sourceType, raw.sourceType);
    expect(storedRaw.single.body, raw.body);
    expect(storedRaw.single.sourceHash, raw.sourceHash);

    expect(storedExpenses, hasLength(1));
    expect(storedExpenses.single.id, expense.id);
    expect(storedExpenses.single.amount, expense.amount);
    expect(storedExpenses.single.merchantName, expense.merchantName);
    expect(storedExpenses.single.categoryId, expense.categoryId);
    expect(
      storedExpenses.single.confirmationStatus,
      expense.confirmationStatus,
    );
    expect(storedExpenses.single.confirmedBy, expense.confirmedBy);
    expect(storedExpenses.single.candidateIds, expense.candidateIds);
    expect(storedExpenses.single.syncStatus, expense.syncStatus);

    await database.close();
  });
}

import 'package:billlearn/src/data/repositories/in_memory_expense_repository.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stores raw notifications separately from expenses', () async {
    final repository = InMemoryExpenseRepository();
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
      candidateIds: const ['candidate-1'],
      createdAt: DateTime(2026, 5, 14, 12, 31),
      updatedAt: DateTime(2026, 5, 14, 12, 31),
      syncStatus: SyncStatus.localOnly,
    );

    await repository.saveRawNotification(raw);
    await repository.saveExpense(expense);

    expect(await repository.watchRawNotifications().first, [raw]);
    expect(await repository.watchExpenses().first, [expense]);

    await repository.dispose();
  });

  test('finds transaction candidate by id', () async {
    final repository = InMemoryExpenseRepository();
    final candidate = TransactionCandidate(
      id: 'candidate-1',
      rawNotificationId: 'raw-1',
      amount: 12300,
      merchantName: '스타벅스',
      paymentMethodHint: '신한카드',
      occurredAt: DateTime(2026, 5, 14, 12, 30),
      sourceType: RawNotificationSourceType.sms,
      parseConfidence: 0.9,
      parseStatus: ParseStatus.parsed,
      createdAt: DateTime(2026, 5, 14, 12, 31),
    );

    await repository.saveTransactionCandidate(candidate);

    final storedCandidate = await repository.getTransactionCandidateById(
      candidate.id,
    );

    expect(storedCandidate?.id, candidate.id);
    expect(storedCandidate?.merchantName, candidate.merchantName);
    expect(
      await repository.getTransactionCandidateById('missing-candidate'),
      isNull,
    );

    await repository.dispose();
  });
}

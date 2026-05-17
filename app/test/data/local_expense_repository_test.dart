import 'package:billlearn/src/data/local/app_database.dart';
import 'package:billlearn/src/data/repositories/local_expense_repository.dart';
import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
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
    final candidate = TransactionCandidate(
      id: 'candidate-1',
      rawNotificationId: raw.id,
      amount: 12300,
      merchantName: '스타벅스',
      paymentMethodHint: '신한카드',
      occurredAt: DateTime(2026, 5, 14, 12, 30),
      sourceType: RawNotificationSourceType.sms,
      parseConfidence: 0.9,
      parseStatus: ParseStatus.parsed,
      createdAt: DateTime(2026, 5, 14, 12, 31),
    );
    final classification = ClassificationResult(
      id: 'classification-1',
      candidateIds: const ['candidate-1'],
      isDuplicate: false,
      isTransferLike: false,
      isExpense: true,
      requiresReview: false,
      reasonCodes: const ['stable_payment_signal'],
      confidence: 0.9,
      createdAt: DateTime(2026, 5, 14, 12, 31),
      userFeedback: null,
    );

    await repository.saveRawNotification(raw);
    await repository.saveTransactionCandidate(candidate);
    await repository.saveClassificationResult(classification);
    await repository.saveExpense(expense);

    final storedRaw = await repository.watchRawNotifications().first;
    final rawBySourceHash = await repository.getRawNotificationBySourceHash(
      raw.sourceHash,
    );
    final storedExpenses = await repository.watchExpenses().first;
    final expenseSnapshot = await repository.getExpenses();
    final storedCandidates = await repository.getCandidatesForRawNotification(
      raw.id,
    );
    final storedCandidateById = await repository.getTransactionCandidateById(
      candidate.id,
    );
    final storedClassification = await repository
        .getClassificationResultByCandidateId(candidate.id);

    expect(storedRaw, hasLength(1));
    expect(storedRaw.single.id, raw.id);
    expect(storedRaw.single.sourceType, raw.sourceType);
    expect(storedRaw.single.body, raw.body);
    expect(storedRaw.single.sourceHash, raw.sourceHash);
    expect(rawBySourceHash?.id, raw.id);
    expect(storedCandidates, hasLength(1));
    expect(storedCandidates.single.id, candidate.id);
    expect(storedCandidates.single.amount, candidate.amount);
    expect(storedCandidates.single.merchantName, candidate.merchantName);
    expect(storedCandidates.single.parseStatus, candidate.parseStatus);
    expect(storedCandidateById?.id, candidate.id);
    expect(storedCandidateById?.paymentMethodHint, candidate.paymentMethodHint);
    expect(
      await repository.getTransactionCandidateById('missing-candidate'),
      isNull,
    );
    expect(storedClassification?.id, classification.id);
    expect(storedClassification?.candidateIds, classification.candidateIds);
    expect(storedClassification?.reasonCodes, classification.reasonCodes);
    expect(storedClassification?.isExpense, isTrue);

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
    expect(expenseSnapshot, hasLength(1));
    expect(expenseSnapshot.single.id, expense.id);

    await repository.updateExpense(
      expense.copyWith(
        confirmationStatus: ConfirmationStatus.rejected,
        confirmedBy: ConfirmedBy.user,
        updatedAt: DateTime(2026, 5, 14, 12, 33),
      ),
    );
    final updatedExpense = await repository.getExpenseById(expense.id);
    expect(updatedExpense?.confirmationStatus, ConfirmationStatus.rejected);
    expect(updatedExpense?.confirmedBy, ConfirmedBy.user);

    await database.close();
  });
}

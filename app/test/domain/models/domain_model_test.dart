import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('raw notification stores original source fields', () {
    final raw = RawNotification(
      id: 'raw-1',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[승인] 12,300원 스타벅스 05/14 12:30',
      receivedAt: DateTime(2026, 5, 14, 12, 30),
      sourceHash: 'hash-1',
      createdAt: DateTime(2026, 5, 14, 12, 31),
    );

    expect(raw.sourceType, RawNotificationSourceType.sms);
    expect(raw.sender, '1588-0000');
    expect(raw.body, contains('스타벅스'));
  });

  test('candidate remains separate from final expense', () {
    final candidate = TransactionCandidate(
      id: 'candidate-1',
      rawNotificationId: 'raw-1',
      amount: 12300,
      merchantName: '스타벅스',
      paymentMethodHint: '신한카드',
      occurredAt: DateTime(2026, 5, 14, 12, 30),
      sourceType: RawNotificationSourceType.sms,
      parseConfidence: 0.92,
      parseStatus: ParseStatus.parsed,
      createdAt: DateTime(2026, 5, 14, 12, 31),
    );

    final expense = ExpenseTransaction(
      id: 'expense-1',
      amount: candidate.amount,
      merchantName: candidate.merchantName,
      categoryId: 'cafe',
      spentAt: candidate.occurredAt,
      confirmationStatus: ConfirmationStatus.confirmed,
      confirmedBy: ConfirmedBy.rule,
      candidateIds: const ['candidate-1'],
      createdAt: DateTime(2026, 5, 14, 12, 31),
      updatedAt: DateTime(2026, 5, 14, 12, 31),
      syncStatus: SyncStatus.localOnly,
    );

    expect(expense.candidateIds, contains(candidate.id));
    expect(expense.syncStatus, SyncStatus.localOnly);
  });

  test('classification result can require review', () {
    final result = ClassificationResult(
      id: 'classification-1',
      candidateIds: const ['candidate-1'],
      isDuplicate: false,
      isTransferLike: true,
      isExpense: false,
      requiresReview: true,
      reasonCodes: const ['transfer_like_keyword'],
      confidence: 0.7,
      createdAt: DateTime(2026, 5, 14, 12, 31),
      userFeedback: null,
    );

    expect(result.requiresReview, isTrue);
    expect(result.reasonCodes, contains('transfer_like_keyword'));
  });
}

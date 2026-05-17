import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/data/repositories/in_memory_expense_repository.dart';
import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:billlearn/src/features/transaction_detail/transaction_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows selected expense details', (tester) async {
    final repository = InMemoryExpenseRepository();
    await repository.saveExpense(
      ExpenseTransaction(
        id: 'expense-1',
        amount: 23400,
        merchantName: '배달의민족',
        categoryId: 'food',
        spentAt: DateTime(2026, 5, 14, 12, 45),
        confirmationStatus: ConfirmationStatus.confirmed,
        confirmedBy: ConfirmedBy.rule,
        candidateIds: const ['candidate-1'],
        createdAt: DateTime(2026, 5, 14, 12, 46),
        updatedAt: DateTime(2026, 5, 14, 12, 46),
        syncStatus: SyncStatus.localOnly,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [expenseRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: TransactionDetailScreen(transactionId: 'expense-1'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('배달의민족'), findsOneWidget);
    expect(find.text('23,400원'), findsOneWidget);
    expect(find.text('확정됨'), findsOneWidget);
    expect(find.text('후보: candidate-1'), findsOneWidget);

    await repository.dispose();
  });

  testWidgets('shows parsing and classification evidence for candidate', (
    tester,
  ) async {
    final repository = InMemoryExpenseRepository();
    await repository.saveTransactionCandidate(
      TransactionCandidate(
        id: 'candidate-1',
        rawNotificationId: 'raw-1',
        amount: 23400,
        merchantName: '배달의민족',
        paymentMethodHint: '신한카드',
        occurredAt: DateTime(2026, 5, 14, 12, 45),
        sourceType: RawNotificationSourceType.push,
        parseConfidence: 0.9,
        parseStatus: ParseStatus.parsed,
        createdAt: DateTime(2026, 5, 14, 12, 46),
      ),
    );
    await repository.saveClassificationResult(
      ClassificationResult(
        id: 'classification-1',
        candidateIds: const ['candidate-1'],
        isDuplicate: false,
        isTransferLike: false,
        isExpense: true,
        requiresReview: false,
        reasonCodes: const ['stable_payment_signal'],
        confidence: 0.92,
        createdAt: DateTime(2026, 5, 14, 12, 46),
        userFeedback: null,
      ),
    );
    await repository.saveExpense(
      ExpenseTransaction(
        id: 'expense-1',
        amount: 23400,
        merchantName: '배달의민족',
        categoryId: 'food',
        spentAt: DateTime(2026, 5, 14, 12, 45),
        confirmationStatus: ConfirmationStatus.confirmed,
        confirmedBy: ConfirmedBy.rule,
        candidateIds: const ['candidate-1'],
        createdAt: DateTime(2026, 5, 14, 12, 46),
        updatedAt: DateTime(2026, 5, 14, 12, 46),
        syncStatus: SyncStatus.localOnly,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [expenseRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: TransactionDetailScreen(transactionId: 'expense-1'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('판별 근거'), findsOneWidget);
    expect(find.text('후보: candidate-1'), findsOneWidget);
    expect(find.text('가맹점'), findsWidgets);
    expect(find.text('배달의민족'), findsWidgets);
    expect(find.text('결제 수단'), findsOneWidget);
    expect(find.text('신한카드'), findsOneWidget);
    expect(find.text('파싱 상태'), findsOneWidget);
    expect(find.text('파싱됨 · 90%'), findsOneWidget);
    expect(find.text('실제 지출'), findsOneWidget);
    expect(find.text('중복 아님'), findsOneWidget);
    expect(find.text('이체/충전 아님'), findsOneWidget);
    expect(find.text('검토 불필요'), findsOneWidget);
    expect(find.text('신뢰도 92%'), findsOneWidget);
    expect(find.text('stable_payment_signal'), findsOneWidget);

    await repository.dispose();
  });

  testWidgets('rejects expense when user says it is not spending', (
    tester,
  ) async {
    final repository = InMemoryExpenseRepository();
    await repository.saveExpense(
      ExpenseTransaction(
        id: 'expense-1',
        amount: 5000,
        merchantName: '동백전 충전',
        categoryId: null,
        spentAt: DateTime(2026, 5, 14, 12),
        confirmationStatus: ConfirmationStatus.needsReview,
        confirmedBy: ConfirmedBy.rule,
        candidateIds: const ['candidate-1'],
        createdAt: DateTime(2026, 5, 14, 12, 1),
        updatedAt: DateTime(2026, 5, 14, 12, 1),
        syncStatus: SyncStatus.localOnly,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [expenseRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: TransactionDetailScreen(transactionId: 'expense-1'),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('아니요'));
    await tester.pumpAndSettle();

    final expense = await repository.getExpenseById('expense-1');
    expect(expense?.confirmationStatus, ConfirmationStatus.rejected);
    expect(expense?.confirmedBy, ConfirmedBy.user);
    expect(find.text('제외됨'), findsOneWidget);

    await repository.dispose();
  });
}

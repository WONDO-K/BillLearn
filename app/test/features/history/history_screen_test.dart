import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/data/repositories/in_memory_expense_repository.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/features/history/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows stored expenses in recent order', (tester) async {
    final repository = InMemoryExpenseRepository();
    await repository.saveExpense(
      _expense(
        id: 'expense-1',
        merchantName: '스타벅스',
        amount: 5600,
        spentAt: DateTime(2026, 5, 14, 9, 15),
      ),
    );
    await repository.saveExpense(
      _expense(
        id: 'expense-2',
        merchantName: '네이버페이',
        amount: 39800,
        spentAt: DateTime(2026, 5, 15, 11, 32),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [expenseRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: HistoryScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('잔여 기간'), findsOneWidget);
    expect(find.text('전체 카테고리'), findsOneWidget);
    expect(find.text('전체 지출'), findsOneWidget);
    expect(find.text('45,400원'), findsOneWidget);
    expect(find.text('2건'), findsOneWidget);
    expect(find.text('확정 2건'), findsOneWidget);
    expect(find.text('5월 15일 (금)'), findsOneWidget);
    expect(find.text('네이버페이'), findsOneWidget);
    expect(find.text('39,800원'), findsOneWidget);
    expect(find.text('5월 14일 (목)'), findsOneWidget);
    expect(find.text('스타벅스'), findsOneWidget);
    expect(find.text('5,600원'), findsOneWidget);

    await repository.dispose();
  });

  testWidgets('marks rejected expenses as excluded in history', (tester) async {
    final repository = InMemoryExpenseRepository();
    await repository.saveExpense(
      _expense(
        id: 'expense-1',
        merchantName: '동백전 충전',
        amount: 5000,
        spentAt: DateTime(2026, 5, 14, 12),
        confirmationStatus: ConfirmationStatus.rejected,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [expenseRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: HistoryScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('동백전 충전'), findsOneWidget);
    expect(find.text('제외 1건'), findsOneWidget);
    expect(find.text('제외됨'), findsOneWidget);
    expect(find.text('5,000원'), findsOneWidget);

    await repository.dispose();
  });

  testWidgets('explains needs review expenses in history', (tester) async {
    final repository = InMemoryExpenseRepository();
    await repository.saveExpense(
      _expense(
        id: 'expense-1',
        merchantName: '계좌이체 의심',
        amount: 5000,
        spentAt: DateTime(2026, 5, 14, 12),
        confirmationStatus: ConfirmationStatus.needsReview,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [expenseRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: HistoryScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('계좌이체 의심'), findsOneWidget);
    expect(find.text('확인 필요'), findsOneWidget);
    expect(find.textContaining('실제 지출인지 확인해주세요'), findsOneWidget);

    await repository.dispose();
  });
}

ExpenseTransaction _expense({
  required String id,
  required String merchantName,
  required int amount,
  required DateTime spentAt,
  ConfirmationStatus confirmationStatus = ConfirmationStatus.confirmed,
}) {
  return ExpenseTransaction(
    id: id,
    amount: amount,
    merchantName: merchantName,
    categoryId: null,
    spentAt: spentAt,
    confirmationStatus: confirmationStatus,
    confirmedBy: ConfirmedBy.rule,
    candidateIds: ['candidate-$id'],
    createdAt: spentAt,
    updatedAt: spentAt,
    syncStatus: SyncStatus.localOnly,
  );
}

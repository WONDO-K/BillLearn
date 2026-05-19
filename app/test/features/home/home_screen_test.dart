import 'package:billlearn/src/app/billlearn_app.dart';
import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/data/repositories/in_memory_expense_repository.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows BillLearn home shell', (tester) async {
    final repository = InMemoryExpenseRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [expenseRepositoryProvider.overrideWithValue(repository)],
        child: const BillLearnApp(),
      ),
    );
    await tester.pump();

    expect(find.text('홈'), findsOneWidget);
    expect(find.text('이번 달 실제 지출'), findsOneWidget);
    expect(find.text('영수증으로부터 배운 지출'), findsOneWidget);
    expect(find.text('자동 수집된 결제 알림에서 실제 소비만 남겼어요.'), findsOneWidget);
    expect(find.text('AI가 헷갈린 거래'), findsOneWidget);
    expect(find.text('최근 내역'), findsOneWidget);
    expect(find.bySemanticsLabel('BillLearn mascot'), findsNWidgets(2));

    await repository.dispose();
  });

  testWidgets('shows stored monthly expense total and recent expense', (
    tester,
  ) async {
    final repository = InMemoryExpenseRepository();
    await repository.saveExpense(
      ExpenseTransaction(
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
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [expenseRepositoryProvider.overrideWithValue(repository)],
        child: const BillLearnApp(),
      ),
    );
    await tester.pump();

    expect(find.text('12,300원'), findsNWidgets(2));
    expect(find.text('스타벅스'), findsOneWidget);

    await repository.dispose();
  });

  testWidgets('opens detail screen from needs review item', (tester) async {
    final repository = InMemoryExpenseRepository();
    await repository.saveExpense(
      ExpenseTransaction(
        id: 'expense-review',
        amount: 5000,
        merchantName: '동백전 충전',
        categoryId: null,
        spentAt: DateTime(2026, 5, 14, 12),
        confirmationStatus: ConfirmationStatus.needsReview,
        confirmedBy: ConfirmedBy.rule,
        candidateIds: const ['candidate-review'],
        createdAt: DateTime(2026, 5, 14, 12, 1),
        updatedAt: DateTime(2026, 5, 14, 12, 1),
        syncStatus: SyncStatus.localOnly,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [expenseRepositoryProvider.overrideWithValue(repository)],
        child: const BillLearnApp(),
      ),
    );
    await tester.pump();

    expect(find.text('검토하러 가기'), findsOneWidget);

    await tester.tap(find.text('검토하러 가기'));
    await tester.pumpAndSettle();

    expect(find.text('상세'), findsOneWidget);
    expect(find.text('동백전 충전'), findsOneWidget);
    expect(find.text('확인 필요'), findsWidgets);
    expect(find.widgetWithText(FilledButton, '맞아요'), findsOneWidget);

    await repository.dispose();
  });
}

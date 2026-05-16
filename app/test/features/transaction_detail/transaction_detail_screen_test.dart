import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/data/repositories/in_memory_expense_repository.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
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
    expect(find.text('candidate-1'), findsOneWidget);

    await repository.dispose();
  });
}

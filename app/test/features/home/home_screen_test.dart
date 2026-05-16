import 'package:billlearn/src/app/billlearn_app.dart';
import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/data/repositories/in_memory_expense_repository.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
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
    expect(find.text('최근 내역'), findsOneWidget);

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
}

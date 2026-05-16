import 'package:billlearn/src/data/local/app_database.dart';
import 'package:billlearn/src/data/repositories/local_expense_repository.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/repositories/expense_repository.dart';
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
